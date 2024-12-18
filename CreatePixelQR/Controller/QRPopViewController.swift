//
//  QRPopViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/13/24.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class QRPopViewController: UIViewController {
    
    @IBOutlet var qrPopView: QRPopView!
    
    let qrProcessor = QRProcessor()
    var receiveData: String?
    var qrCodeType: QRCase?
    var qrImage: UIImage?
    
    var updateParentView: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrPopView.setUI()
        
        // UIPanGestureRecognizer 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        if let data = receiveData {
            qrCodeType = determineQRCodeType(from: data)
            setupUI(with: data, type: qrCodeType)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.updateParentView?()
        print("QRPopViewController did disappear")
    }
    
    //halfSizePresentationVC 드롭 다운
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // 아래로 스와이프한 경우에만 처리
        if translation.y > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        
        // 제스처가 종료된 경우
        if gesture.state == .ended {
            if translation.y > 150 {
                // 일정 거리 이상 스와이프 시 dismiss
                dismiss(animated: true, completion: nil)
            } else {
                // 스와이프가 일정 거리 미만이면 원래 위치로 돌아감
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }
    
    // QR 코드 타입 판별
    func determineQRCodeType(from data: String) -> QRCase {
        if let url = URL(string: data), UIApplication.shared.canOpenURL(url) {
            return .url
        } else if data.hasPrefix("WIFI:") {
            return .wifi
        } else if let phoneRegex = try? NSRegularExpression(pattern: "^tel:[0-9]+$", options: []),
                  phoneRegex.firstMatch(in: data, options: [], range: NSRange(location: 0, length: data.count)) != nil {
            return .phone
        } else {
            return .text
        }
    }
    
    // UI 구성
    func setupUI(with data: String, type: QRCase?) {
        qrPopView.resultTypeLabel.text = "QR 코드 타입: \(type?.categoryCase ?? "알 수 없음")"
        
        //qrPopView.resultLabel.text = data
        qrPopView.applyUnderline(to: qrPopView.resultLabel, text: data)
        qrPopView.containerView.isUserInteractionEnabled = true
        // UIView에 터치 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        qrPopView.containerView.addGestureRecognizer(tapGesture)
        
        switch type {
        case .url:
            if let qrcode = qrProcessor.generateQRCode(from: .url(data), clearRatio: 0.0, dotImage: nil) {
                qrPopView.qrImageView.image = qrcode
            }
            
        case .wifi:
            if let wifiInfo = parseWiFiData(data) {
                if let qrCode = qrProcessor.generateQRCode(
                    from: .wifi(ssid: wifiInfo.ssid, password: wifiInfo.password, security: wifiInfo.security, hidden: wifiInfo.hidden),
                    clearRatio: 0.0,
                    dotImage: nil
                ) {
                    qrPopView.qrImageView.image = qrCode
                }
            } else {
                print("Wi-Fi 데이터 파싱 실패")
            }
        case .phone:
            if let qrCode = qrProcessor.generateQRCode(from: .phone(data), clearRatio: 0.0, dotImage: nil) {
                qrPopView.qrImageView.image = qrCode
            }
            
        case .text:
            if let qrCode = qrProcessor.generateQRCode(from: .text(data), clearRatio: 0.0, dotImage: nil) {
                qrPopView.qrImageView.image = qrCode
            }
        default:
            break
            
        }
    }
    
    func parseWiFiData(_ data: String) -> (ssid: String, password: String, security: String, hidden: Bool)? {
        guard data.hasPrefix("WIFI:") else { return nil }

        let components = data
            .replacingOccurrences(of: "WIFI:", with: "")
            .components(separatedBy: ";")

        var ssid = ""
        var password = ""
        var security = "WPA" // 기본값
        var hidden = false

        for component in components {
            if component.hasPrefix("S:") {
                ssid = component.replacingOccurrences(of: "S:", with: "")
            } else if component.hasPrefix("P:") {
                password = component.replacingOccurrences(of: "P:", with: "")
            } else if component.hasPrefix("T:") {
                security = component.replacingOccurrences(of: "T:", with: "")
            } else if component.hasPrefix("H:") {
                hidden = component.replacingOccurrences(of: "H:", with: "") == "true"
            }
        }

        return (ssid, password, security, hidden)
    }
    
    @objc func handleTap() {
         guard let data = receiveData else { return }

         switch qrCodeType {
         case .url:
             openURL(data)
         case .phone:
             callPhoneNumber(data)
         case .wifi:
             showWiFiInfo(data)
         case .text:
             showTextAlert(data)
         default:
             print("지원되지 않는 타입")
         }
     }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func callPhoneNumber(_ phoneNumber: String) {
        guard let url = URL(string: phoneNumber) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Wi-Fi 정보 표시
    func showWiFiInfo(_ wifiData: String) {
        if let wifiInfo = parseWiFiData(wifiData) {
            let message = "SSID: \(wifiInfo.ssid)\nPassword: \(wifiInfo.password)"
            
            // Alert 생성
            let alert = UIAlertController(title: "Wi-Fi 정보", message: message, preferredStyle: .alert)
            
            // "취소" 버튼 추가
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            // "연결" 버튼 추가
            let connectAction = UIAlertAction(title: "연결", style: .default) { _ in
                self.connectToWiFi(ssid: wifiInfo.ssid, password: wifiInfo.password, security: wifiInfo.security, isHidden: wifiInfo.hidden)
                
              
            }
            alert.addAction(connectAction)
            
            // Alert 표시
            present(alert, animated: true, completion: nil)
        } else {
            showAlert(title: "Wi-Fi 정보", message: "Wi-Fi 데이터를 읽을 수 없습니다.")
        }
    }
    
    // 텍스트 표시
    func showTextAlert(_ text: String) {
        showAlert(title: "텍스트", message: text)
    }
    

    // 공통 알림 표시
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func connectToWiFi(ssid: String, password: String, security: String, isHidden: Bool) {
        print("입력 값: SSID=\(ssid), Password=\(password), Security=\(security), isHidden=\(isHidden)")

        let hotspotConfiguration: NEHotspotConfiguration

        // 보안 방식에 따라 hotspotConfiguration 생성
        if security.contains("WPA") {
            print("WPA/WPA2 보안 방식으로 설정")
            hotspotConfiguration = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        } else if security.contains("WEP") {
            print("WEP 보안 방식으로 설정")
            hotspotConfiguration = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: true)
        } else if security.contains("OPEN") {
            print("Open Network로 설정")
            hotspotConfiguration = NEHotspotConfiguration(ssid: ssid)
        } else {
            print("알 수 없는 보안 방식: \(security)")
            self.showAlert(title: "Wi-Fi 연결 실패", message: "지원되지 않는 보안 방식입니다: \(security)")
            return
        }

        // 숨겨진 네트워크 처리
        hotspotConfiguration.hidden = isHidden
        hotspotConfiguration.joinOnce = false // 지속적인 연결 유지

        // 기존 설정 제거
        NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: ssid)

        // 연결 시도
        NEHotspotConfigurationManager.shared.apply(hotspotConfiguration) { error in
            if let error = error {
                print("Wi-Fi 연결 실패: \(error.localizedDescription)")
                self.showAlert(title: "Wi-Fi 연결 실패", message: error.localizedDescription)
            } else {
                print("Wi-Fi 연결 성공!")
                self.showAlert(title: "Wi-Fi 연결 성공", message: "네트워크에 성공적으로 연결되었습니다.")
            }
        }
    }

    
}



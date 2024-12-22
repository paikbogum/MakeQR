//
//  ViewController.swift
//  CreatePixelQR
//

//  Created by 백현진 on 11/21/24.
//
import UIKit
import Photos


class ResultViewController: UIViewController {
    @IBOutlet var resultView: ResultView!
    
    var receiveCroppedImage: UIImage?
   // var receiveUrl: String?
    
    var qrType: QRCodeType = .url("https://default.com")
    
    let qrManager = QRHistoryManager.shared
    
    private var qrProcessor = QRProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultView.setUI()
        makeQRResult()
        resultView.showLottieAnimationWithLabel(text: "QR코드를 생성 중입니다...")
        
        // 5초 후 애니메이션과 레이블 제거
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.resultView.removeLottieAnimationAndLabel()
            self.resultView.resultImageView.isHidden = false
            self.resultView.randomMent.isHidden = false
            self.resultView.downLoadButton.isHidden = false
            self.resultView.shareButton.isHidden = false
            self.resultView.kakaoButton.isHidden = false
            self.randomMent(ments: ["걸작입니다!", "재밌는 결과물인데요?", "Cool!", "갤러리에 전시해도 되겠어요."])
        }
    }
    
    private func randomMent(ments: [String]) {
        resultView.randomMent.text = ments[Int.random(in: 0...3)]
    }
    
    //dotImageQR Making
    private func makeQRResult() {
        guard let croppedImage = receiveCroppedImage else {
            print("Cropped image not found.")
            return
        }
        
        // QR 코드 타입에 따라 QR 코드 생성
        switch qrType {
        case .url(let urlString):
            print("Generating URL QR Code with URL: \(urlString)")
            qrManager.saveURLHistory(url: urlString)
        case .wifi(let ssid, let password, let security, let hidden):
            print("Generating Wi-Fi QR Code with SSID: \(ssid), Password: \(password), Security: \(security), Hidden: \(hidden)")
            qrManager.saveWiFiHistory(ssid: ssid, password: password, security: security, isHidden: hidden)
        case .phone(let phoneNumber):
            print("Generating Phone QR Code with Number: \(phoneNumber)")
            qrManager.savePhoneHistory(phoneNumber: phoneNumber)
        case .text(let text):
            print("Generating Text QR Code with Text: \(text)")
            qrManager.saveTextHistory(text: text)
        }

        if let qrCode = qrProcessor.generateQRCode(from: qrType, clearRatio: 0.3, dotImage: nil),
           let dotImage = qrProcessor.processImageToDots(image: croppedImage, gridSize: 50, cellSize: 50),
           let finalQRCode = qrProcessor.overlayDotImageOnClearedQRCode(qrCode: qrCode, dotImage: dotImage, clearRatio: 0.3, dotRatio: 0.95) {
            
            // 결과를 이미지 뷰에 표시
            resultView.resultImageView.image = finalQRCode
        } else {
            print("Failed to generate QR code with dot overlay.")
        }
    }
    
    @IBAction func downLoadButtonTapped(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized, let image = self.resultView.resultImageView.image else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success {
                        // 저장 성공 시 알림 표시
                        let alert = UIAlertController(title: "저장 완료", message: "사진이 앨범에 저장되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else if let error = error {
                        // 저장 실패 시 알림 표시
                        let alert = UIAlertController(title: "저장 실패", message: "사진 저장 중 오류가 발생했습니다: \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func kakaoShareButtonTapped(_ sender: Any) {
        // resultView.resultImageView.image가 nil인지 확인
        guard let imageToShare = resultView.resultImageView.image else {
            print("No image found in resultView")
            return
        }
        
        // 카카오 서버에 이미지 업로드
        KakaoImageShareManager.shared.uploadImageToKakaoServer(inPutImage: imageToShare) { [weak self] imageUrlString in
            guard let self = self else { return }
            
            print("Image upload completion called")
            
            // 업로드 성공 여부 확인
            if let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) {
                // 업로드된 URL을 통해 카카오톡 공유
                print("Calling shareImageViaKakao with URL: \(imageUrl)")
                KakaoImageShareManager.shared.shareImageViaKakao(imageUrl: imageUrl)
            } else {
                print("Failed to upload image or invalid URL")
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        // 공유할 텍스트와 이미지 설정
        let textToShare = "이 이미지를 확인해 보세요!"
        guard let imageToShare = resultView.resultImageView.image else {
            print("이미지를 로드할 수 없습니다.")
            return
        }
        
        // UIActivityViewController 생성
        let activityViewController = UIActivityViewController(activityItems: [textToShare, imageToShare], applicationActivities: nil)
        
        // iPad에서 팝업이 올바르게 나타나도록 설정 (iPhone은 필요 없음)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // ActivityViewController 표시
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


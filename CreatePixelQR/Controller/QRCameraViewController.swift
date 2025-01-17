//
//  QRCameraViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/13/24.
//

import UIKit
import AVFoundation

class QRCameraViewController: UIViewController {
    
    private let overlayView = QRFrameOverlayView()
    
    @IBOutlet var qrCameraView: QRCameraView!
    let halfSizeTransitioningDelegate = HalfSizeTransitioningDelegate()
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView! // QR 코드 영역 표시
    var currentQRCodeImage: UIImage? // 캡처한 QR 이미지 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCameraView.setUI()
        setupCamera()
        setupQRCodeFrame()
    }
    
    deinit {
        stopSession()
    }
    
    func qrCodeDetected(_ code: String) {
        print("QR 코드 감지: \(code)")
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "QRPopViewController") as? QRPopViewController else { return }
        
        nextVC.receiveData = code
        nextVC.modalPresentationStyle = .custom
        nextVC.transitioningDelegate = halfSizeTransitioningDelegate
        nextVC.updateParentView = { [weak self] in
            self?.updateView()
        }
        
        self.present(nextVC, animated: true)
    }
    
    func updateView() {
        // 백그라운드 스레드에서 세션 재시작
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            if self.captureSession?.isRunning == false {
                self.captureSession?.startRunning()
            }
            
            // UI와 관련된 작업은 메인 스레드에서 실행
            DispatchQueue.main.async {
                self.qrCodeFrameView.isHidden = true
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopSession() // 탭 이탈 시 세션 정지
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCamera()
        setupQRCodeFrame()
        showToast(message: "QR코드를 화면 중앙에 맞춰주세요!")
    }
    
    func stopSession() {
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    private func setupQRFrameOverlay() {
        guard let previewLayer = previewLayer else { return }
        
        // 중앙에 위치한 네모 프레임의 크기 설정
        let frameWidth: CGFloat = 200
        let frameHeight: CGFloat = 200
        
        // previewLayer의 중심 좌표 계산
        let centerX = previewLayer.frame.midX
        let centerY = previewLayer.frame.midY
        
        // overlayView 설정
        overlayView.frame = CGRect(
            x: centerX - (frameWidth / 2),
            y: centerY - (frameHeight / 2),
            width: frameWidth,
            height: frameHeight
        )
        overlayView.backgroundColor = .clear // 배경 투명
        
        // 카메라 뷰 상단에 추가
        qrCameraView.cameraView.addSubview(overlayView)
        
        // overlayView를 가장 위로 설정
        qrCameraView.cameraView.bringSubviewToFront(overlayView)
    }
}

extension QRCameraViewController: AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    func setupCamera() {
        // 카메라 세션 초기화
        captureSession = AVCaptureSession()
        
        // 디바이스 설정 (카메라)
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("카메라를 사용할 수 없습니다.")
            return
        }
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("카메라 입력을 추가할 수 없습니다.")
                return
            }
        } catch {
            print("카메라 입력 에러: \(error)")
            return
        }
        
        // 메타데이터 출력 설정
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr] // QR 코드만 감지
        } else {
            print("메타데이터 출력을 추가할 수 없습니다.")
            return
        }
        
        // 카메라 프리뷰 레이어 추가
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = qrCameraView.cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        qrCameraView.cameraView.layer.addSublayer(previewLayer)
        
        // 카메라 시작
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
        setupQRFrameOverlay()
    }
    
    func setupQRCodeFrame() {
        // QR 코드 영역 표시 뷰 생성
        qrCodeFrameView = UIView()
        qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
        qrCodeFrameView.layer.borderWidth = 3
        qrCodeFrameView.layer.cornerRadius = 5
        qrCodeFrameView.clipsToBounds = true
        qrCodeFrameView.isHidden = true // 초기에는 숨김
        qrCameraView.cameraView.addSubview(qrCodeFrameView)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // QR 코드 감지 여부 확인
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let transformedObject = previewLayer.transformedMetadataObject(for: readableObject) else { return }
            
            // QR 코드 영역 업데이트
            qrCodeFrameView.frame = transformedObject.bounds
            qrCodeFrameView.isHidden = false
            
            if let stringValue = readableObject.stringValue {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // 진동
                
                print("QR 코드 감지: \(stringValue)")
                captureSession.stopRunning()
                // QR 이미지 추출
                
                self.qrCodeDetected(stringValue)
                
            }
        } else {
            // QR 코드가 감지되지 않으면 숨김
            qrCodeFrameView.isHidden = true
        }
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let toastWidth: CGFloat = UIScreen.main.bounds.width * 0.8
        let toastHeight: CGFloat = 50
        toastLabel.frame = CGRect(
            x: (UIScreen.main.bounds.width - toastWidth) / 2,
            y: UIScreen.main.bounds.height - toastHeight - 150,
            width: toastWidth,
            height: toastHeight
        )

        UIApplication.shared.windows.first?.addSubview(toastLabel)

        UIView.animate(withDuration: 1.0, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}

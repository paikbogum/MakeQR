//
//  QRCameraViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/13/24.
//

import UIKit
import AVFoundation

class QRCameraViewController: UIViewController {
    
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
    
    /*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }*/
    
    func stopSession() {
        captureSession?.stopRunning()
        captureSession = nil
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
    
}

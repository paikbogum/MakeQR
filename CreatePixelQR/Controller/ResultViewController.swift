//
//  ViewController.swift
//  CreatePixelQR
//

//  Created by 백현진 on 11/21/24.
//
import UIKit
import Photos
import QRCode

class ResultViewController: UIViewController {
    @IBOutlet var resultView: ResultView!
    
    var receiveCroppedImage: UIImage?
    // var receiveUrl: String?
    
    var qrType: QRCodeType = .url("https://default.com")
    
    let qrManager = QRHistoryManager.shared
    
    private var qrProcessor = QRProcessor()
    
    // 2) QR 생성 담당 객체
    private let newQRProcessor = NewQRProcessor()
    
    var receiveQRPercent: CGFloat = 0.3
    var receiveDotVal: Int = 20
    var receiveForegroundColor: UIColor = .black
    var receiveBackgroundColor: UIColor = .white
    var receiveDotColor: UIColor = .black
    var receiveSize: String = "100"
    
    var receiveEyeShape: QREyeShape = .eye_square
    var receiveBodyShape: QRBodyShape = .data_square
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultView.setUI()
        resultView.showLottieAnimationWithLabel(text: "QR코드를 생성 중입니다...")
        
        
        newGenerateQRCode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             self.resultView.removeLottieAnimationAndLabel()
             self.resultView.topContainerView.alpha = 1.0
             self.resultView.resultImageView.isHidden = false
             self.resultView.randomMent.isHidden = false
             self.resultView.downLoadButton.isHidden = false
             self.resultView.shareButton.isHidden = false
             self.resultView.kakaoButton.isHidden = false
             self.randomMent(ments: ["상당한 걸작입니다!", "엄청난 결과물인데요?", "자랑해도 될 만한 결과입니다.", "갤러리에 전시해도 되겠어요."])
             }
        }
        
        /*
        makeQRResult {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             self.resultView.removeLottieAnimationAndLabel()
             self.resultView.topContainerView.alpha = 1.0
             self.resultView.resultImageView.isHidden = false
             self.resultView.randomMent.isHidden = false
             self.resultView.downLoadButton.isHidden = false
             self.resultView.shareButton.isHidden = false
             self.resultView.kakaoButton.isHidden = false
             self.randomMent(ments: ["상당한 걸작입니다!", "엄청난 결과물인데요?", "자랑해도 될 만한 결과입니다.", "갤러리에 전시해도 되겠어요."])
             }
        }*/
    }
    
    
    private func newGenerateQRCode(completion: (() -> Void)? = nil) {
        do {
            // 여기서 text, dimension, 색상 등 원하는 값으로 조절
            let qrImage = try newQRProcessor.createQRCodeBuilderStyle(
                text: "https://www.worldwildlife.org/about",
                dimension: 600,
                foreColor: .systemRed,
                backColor: .white
            )
            
            // 이미지뷰에 표시
            resultView.resultImageView.image = qrImage
            
            completion?()
            
        } catch {
            print("QR 코드 생성 중 오류 발생:", error)
        }
    }
    
    
    
    
    
    private func randomMent(ments: [String]) {
        resultView.randomMent.text = ments[Int.random(in: 0...3)]
    }
    
    //dotImageQR Making
    private func makeQRResult(completion: (() -> Void)? = nil) {
        guard let croppedImage = receiveCroppedImage else {
            print("Cropped image not found.")
            return
        }
        
        // QR 코드 타입에 따라 QR 코드 생성
        switch qrType {
        case .url(let urlString):
            print("Generating URL QR Code with URL: \(urlString)")
            qrManager.saveURLHistory(url: urlString, act: .generated)
        case .wifi(let ssid, let password, let security, let hidden):
            print("Generating Wi-Fi QR Code with SSID: \(ssid), Password: \(password), Security: \(security), Hidden: \(hidden)")
            qrManager.saveWiFiHistory(ssid: ssid, password: password, security: security, isHidden: hidden, act: .generated)
        case .phone(let phoneNumber):
            print("Generating Phone QR Code with Number: \(phoneNumber)")
            qrManager.savePhoneHistory(phoneNumber: phoneNumber, act: .generated)
        case .text(let text):
            print("Generating Text QR Code with Text: \(text)")
            qrManager.saveTextHistory(text: text, act: .generated)
        case .email(let email):
            print("Generating Text QR Code with email: \(email)")
            qrManager.saveEmailHistory(email: email, act: .generated)
        }
        
        if let qrCode = qrProcessor.generateQRCode(from: qrType, clearRatio: (receiveQRPercent * 100).rounded() / 100, dotImage: nil, foregroundColor: receiveForegroundColor, backgroundColor: receiveBackgroundColor),
           let dotImage = qrProcessor.processImageToDots(image: croppedImage, gridSize: 50, cellSize: receiveDotVal, dotFore: receiveDotColor.cgColor, dotBack: receiveBackgroundColor.cgColor),
           let finalQRCode = qrProcessor.overlayDotImageOnClearedQRCode(qrCode: qrCode, dotImage: dotImage, clearRatio: (receiveQRPercent * 100).rounded() / 100, dotRatio: CGFloat(0.95), backgroundColor: receiveBackgroundColor) {
            
            // 결과를 이미지 뷰에 표시
            resultView.resultImageView.image = finalQRCode
            
            completion?()
        } else {
            print("Failed to generate QR code with dot overlay.")
        }
    }
    
    @IBAction func downLoadButtonTapped(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                
                guard status == .authorized, let originalImage = self.resultView.resultImageView.image else { return }
                
                let receiveSizeInt = Int(self.receiveSize)!
                
                // ✅ 강제 리사이징 (사용자 지정 사이즈)
                let resizedImage = self.resizeImage(image: originalImage, targetSize: CGSize(width: receiveSizeInt, height: receiveSizeInt))
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: resizedImage)
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
    
    
    // ✅ 강제 리사이징 함수
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1 // ✅ 스케일 조정 방지 (원본 크기 유지)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
}


//
//  KakaoImageShareManager.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/7/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

class KakaoImageShareManager {
    static let shared = KakaoImageShareManager()
    
    // 이미지 업로드
    func uploadImageToKakaoServer(inPutImage: UIImage, completion: @escaping (String?) -> Void) {
        ShareApi.shared.imageUpload(image: inPutImage) { (imageUploadResult, error) in
            if let error = error {
                print("Image upload failed: \(error.localizedDescription)")
                completion(nil)
            } else if let imageUploadResult = imageUploadResult {
                print("imageUpload() success.")
                // 업로드된 이미지 URL을 completion으로 전달
                let uploadedImageUrl = imageUploadResult.infos.original.url.absoluteString
                print("Uploaded Image URL: \(uploadedImageUrl)")
                completion(uploadedImageUrl)
            }
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
    
    func shareImageViaKakao(imageUrl: URL) {
        // 웹/앱 링크도 모두 빠진 상황
        let content = Content(
            title: "나만의 QR코드를 만들어보세요!",
            imageUrl: imageUrl,
            description: "#QR DIY",
            link: Link( // link가 반드시 필요하긴 하지만, 기본값으로 써도 무방
                webUrl: URL(string:"https://developers.kakao.com")!,
                mobileWebUrl: URL(string:"https://developers.kakao.com")!
            )
        )
        
        // 버튼 배열을 비우고 생성
        let template = FeedTemplate(content: content, buttons: [])

        // 이후 동일하게 JSON -> Template 변환 -> 공유 API 실행
        if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
           let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
            if ShareApi.isKakaoTalkSharingAvailable() {
                ShareApi.shared.shareDefault(templateObject:templateJsonObject) { (linkResult, error) in
                    if let error = error {
                        print("error : \(error)")
                    } else {
                        print("defaultLink(templateObject:templateJsonObject) success.")
                        guard let linkResult = linkResult else { return }
                        UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                    }
                }
            } else {
                print("카카오톡 앱이 디바이스에 없습니다.")
                showToast(message: "카카오톡 앱이 디바이스에 없습니다.")
                // 필요 시 앱스토어 이동 로직
            }
        }
    }
    
    
}

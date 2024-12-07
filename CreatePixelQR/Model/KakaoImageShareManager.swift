//
//  KakaoImageManager.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/7/24.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare

class KakaoImageShareManager {
    
    static let shared = KakaoImageShareManager()
    
    // 카카오 서버에 이미지 업로드
    func uploadImageToKakaoServer(image: UIImage, completion: @escaping (String?) -> Void) {
        ShareApi.shared.imageUpload(image: image) { (imageUploadResult, error) in
            if let error = error {
                print("Image upload failed: \(error.localizedDescription)")
                completion(nil)
            } else if let imageUploadResult = imageUploadResult {
                print("imageUpload() success.")
                
                // 업로드된 이미지 URL 가져오기
                if let imageUrl = imageUploadResult.infos.original.url {
                    print("Uploaded Image URL: \(imageUrl)")
                    completion(imageUrl)
                } else {
                    print("Failed to fetch uploaded image URL.")
                    completion(nil)
                }
            }
        }
    }
    
    // 이미지 URL을 카카오톡으로 공유
    func shareImageViaKakao(imageUrl: String) {
        let template = FeedTemplate(
            content: Content(
                title: "공유된 이미지",
                imageUrl: URL(string: imageUrl)!, description: "카카오톡으로 공유된 이미지입니다.",
                link: Link(
                    webUrl: URL(string: imageUrl),
                    mobileWebUrl: URL(string: imageUrl)
                )
            ),
            buttons: [
                Button(
                    title: "자세히 보기",
                    link: Link(
                        webUrl: URL(string: imageUrl),
                        mobileWebUrl: URL(string: imageUrl)
                    )
                )
            ]
        )
        
        // 카카오톡 링크를 통해 메시지 공유
        if LinkApi.isKakaoLinkAvailable() {
            LinkApi.shared.defaultLink(template: template) { (linkResult, error) in
                if let error = error {
                    print("Failed to share via KakaoTalk: \(error.localizedDescription)")
                } else {
                    print("Successfully shared via KakaoTalk.")
                }
            }
        } else {
            // 카카오톡 미설치 시 웹으로 공유
            if let url = LinkApi.shared.makeSharerUrlforDefaultLink(template: template) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // 카카오톡 이미지 공유를 위한 전체 흐름
    func shareImage(image: UIImage) {
        uploadImageToKakaoServer(image: image) { [weak self] imageUrl in
            guard let self = self else { return }
            if let imageUrl = imageUrl {
                self.shareImageViaKakao(imageUrl: imageUrl)
            } else {
                print("Failed to upload image to Kakao server.")
            }
        }
    }
}


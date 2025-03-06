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
    
    func shareImageViaKakao(imageUrl: URL) {
        let link = Link(webUrl: URL(string:"https://developers.kakao.com")!,
                        mobileWebUrl: URL(string:"https://developers.kakao.com")!)
        
        let appLink = Link(iosExecutionParams: ["key": "value"])
        
        let button = Button(title: "앱에서 보기", link: appLink)
        let button2 = Button(title: "웹으로 보기", link: link)
        
        let content = Content(
            title: "나만의 QR코드를 만들어보세요!",
            imageUrl: imageUrl,
            description: "#QR DIY #나만의 QR을 만들어보세요!",
            link: link
        )
        
        let template = FeedTemplate(content: content, buttons: [button, button2])
        
        // 메시지 템플릿 encode
        if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
            // 생성한 메시지 템플릿 객체를 jsonObject로 변환
            if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                // 카카오톡 앱이 있는지 체크합니다.
                if ShareApi.isKakaoTalkSharingAvailable() {
                    ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
                        if let error = error {
                            print("error : \(error)")
                        }
                        else {
                            print("defaultLink(templateObject:templateJsonObject) success.")
                            guard let linkResult = linkResult else { return }
                            UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                        }
                    }
                } else {
                    // 없을 경우 카카오톡 앱스토어로 이동합니다. (이거 하려면 URL Scheme에 itms-apps 추가 해야함)
                   print("오류오루오류")
                }
            }
        }
    }
}

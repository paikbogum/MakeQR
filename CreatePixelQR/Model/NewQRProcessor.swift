//
//  NewQRProcessor.swift
//  CreatePixelQR
//
//  Created by 백현진 on 3/11/25.
//

import UIKit
import CoreImage
import QRCode


class NewQRProcessor {
    /// QRCode 빌더 패턴을 통해 QR 코드를 생성하는 예시 함수
    ///
    /// - Parameters:
    ///   - text: QR 코드에 담을 문자열(예: URL)
    ///   - dimension: 결과 이미지의 한 변 크기
    ///   - foreColor: 전경(픽셀) 색상
    ///   - backColor: 배경색
    /// - Returns: 생성된 QR 코드(UIImage)
    /// - Throws: QR 코드 생성 과정에서 오류가 발생할 수 있으므로 오류를 던집니다.
    ///
    func createQRCodeBuilderStyle(
        text: String,
        dimension: CGFloat = 600,
        foreColor: UIColor = .black,
        backColor: UIColor = .white
    ) throws -> UIImage {
        // 'image'라는 이름이지만, 실제로는 Data 타입을 반환합니다.
        let imageData = try QRCode.build
            .text(text)
            .quietZonePixelCount(3)
            .foregroundColor(foreColor.cgColor)
            .backgroundColor(backColor.cgColor)
            .background.cornerRadius(3)
            .onPixels.shape(QRCode.PixelShape.CurvePixel())
            .eye.shape(QRCode.EyeShape.Teardrop())
            .generate
            // 이 메서드가 PNG 등 인코딩된 Data를 반환
            .image(dimension: Int(dimension), representation: .png())
        
        // Data -> UIImage 변환 
        guard let uiImage = UIImage(data: imageData) else {
            // 변환에 실패하면 에러를 던지거나 nil을 반환할 수 있습니다.
            throw NSError(domain: "NewQRProcessor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert Data to UIImage"])
        }
        
        return uiImage
    }
    
}

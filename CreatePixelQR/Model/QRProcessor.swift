//
//  QRProcessor.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/26/24.
//

import UIKit
import CoreImage

class QRProcessor {
    // QR 코드 생성
    func generateQRCode(from type: QRCodeType, clearRatio: CGFloat, dotImage: UIImage?) -> UIImage? {
        guard let qrDataString = convertToQRDataString(from: type),
              let data = qrDataString.data(using: .ascii),
              let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        let qrCodeImage = UIImage(cgImage: cgImage)
        
        guard let clearedQRCode = clearCenterOfQRCode(qrCode: qrCodeImage, clearRatio: clearRatio) else { return nil }
        
        if let dotImage = dotImage {
            return overlayDotImageOnClearedQRCode(qrCode: clearedQRCode, dotImage: dotImage, clearRatio: clearRatio, dotRatio: 0.6)
        }
        
        return clearedQRCode
    }
    
    // QR 데이터 타입 변환
    private func convertToQRDataString(from type: QRCodeType) -> String? {
        switch type {
        case .url(let urlString):
            return urlString
        case .wifi(let ssid, let password, let security, let hidden):
            return "WIFI:S:\(ssid);T:\(security);P:\(password);H:\(hidden ? "true" : "false");;"
        case .phone(let phoneNumber):
            return "tel:\(phoneNumber)"
        case .text(let text):
            return text
        }
    }
    
    // 중앙 비우기
    func clearCenterOfQRCode(qrCode: UIImage, clearRatio: CGFloat) -> UIImage? {
        guard let cgImage = qrCode.cgImage else { return nil }
        
        let qrSize = CGSize(width: cgImage.width, height: cgImage.height)
        let clearSize = CGSize(width: qrSize.width * clearRatio, height: qrSize.height * clearRatio)
        let clearOrigin = CGPoint(x: (qrSize.width - clearSize.width) / 2, y: (qrSize.height - clearSize.height) / 2)
        
        UIGraphicsBeginImageContextWithOptions(qrSize, false, 0.0)
        qrCode.draw(in: CGRect(origin: .zero, size: qrSize))
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: clearOrigin, size: clearSize))
        
        let clearedQRCode = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return clearedQRCode
    }
    
    // 도트 이미지 합성
    func overlayDotImageOnClearedQRCode(qrCode: UIImage, dotImage: UIImage, clearRatio: CGFloat, dotRatio: CGFloat) -> UIImage? {
        guard let clearedQRCode = clearCenterOfQRCode(qrCode: qrCode, clearRatio: clearRatio) else { return nil }
        
        let qrSize = clearedQRCode.size
        let clearSize = CGSize(width: qrSize.width * clearRatio, height: qrSize.height * clearRatio)
        let dotSize = CGSize(width: clearSize.width * dotRatio, height: clearSize.height * dotRatio)
        
        UIGraphicsBeginImageContextWithOptions(qrSize, false, 0.0)
        
        clearedQRCode.draw(in: CGRect(origin: .zero, size: qrSize))
        
        let dotOrigin = CGPoint(
            x: (qrSize.width - dotSize.width) / 2,
            y: (qrSize.height - dotSize.height) / 2
        )
        dotImage.draw(in: CGRect(origin: dotOrigin, size: dotSize))
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    
    // 이미지를 도트화
    func processImageToDots(image: UIImage, gridSize: Int, cellSize: Int) -> UIImage? {
        guard let binaryDots = convertImageToBinaryDotsEnhanced(image: image, gridSize: gridSize) else { return nil }
        return binaryDotsToImage(binaryDots: binaryDots, cellSize: cellSize)
    }

    // Binary Dots 생성
    private func convertImageToBinaryDotsEnhanced(image: UIImage, gridSize: Int) -> [[Int]]? {
        guard let inputCGImage = image.cgImage else { return nil }
        
        let originalWidth = inputCGImage.width
        let originalHeight = inputCGImage.height
        let cellWidth = max(1, originalWidth / gridSize)
        let cellHeight = max(1, originalHeight / gridSize)
        
        var binaryDots: [[Int]] = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        guard let context = CGContext(
            data: nil,
            width: originalWidth,
            height: originalHeight,
            bitsPerComponent: 8,
            bytesPerRow: originalWidth,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else { return nil }
        
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight))
        guard let pixelData = context.data else { return nil }
        let pixelPointer = pixelData.bindMemory(to: UInt8.self, capacity: originalWidth * originalHeight)
        
        for y in 0..<gridSize {
            for x in 0..<gridSize {
                var totalBrightness = 0
                var pixelCount = 0
                for row in 0..<cellHeight {
                    for col in 0..<cellWidth {
                        let pixelX = x * cellWidth + col
                        let pixelY = y * cellHeight + row
                        if pixelX < originalWidth && pixelY < originalHeight {
                            let pixelIndex = pixelY * originalWidth + pixelX
                            totalBrightness += Int(pixelPointer[pixelIndex])
                            pixelCount += 1
                        }
                    }
                }
                let averageBrightness = totalBrightness / max(pixelCount, 1)
                binaryDots[y][x] = averageBrightness < 128 ? 1 : 0
            }
        }
        return binaryDots
    }

    // Binary Dots -> UIImage 변환
    private func binaryDotsToImage(binaryDots: [[Int]], cellSize: Int) -> UIImage? {
        let rows = binaryDots.count
        let cols = binaryDots[0].count
        let imageSize = CGSize(width: cols * cellSize, height: rows * cellSize)
        
        UIGraphicsBeginImageContext(imageSize)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let black = UIColor.black.cgColor
        let white = UIColor.white.cgColor
        context.setFillColor(white)
        context.fill(CGRect(origin: .zero, size: imageSize))
        
        for y in 0..<rows {
            for x in 0..<cols {
                let rect = CGRect(
                    x: x * cellSize,
                    y: y * cellSize,
                    width: cellSize,
                    height: cellSize
                )
                context.setFillColor(binaryDots[y][x] == 1 ? black : white)
                context.fill(rect)
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
}

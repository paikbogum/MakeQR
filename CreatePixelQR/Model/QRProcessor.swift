//
//  QRProcessor.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/26/24.
//

import UIKit
import CoreImage
import QRCode


enum Shape {
    case square
    case circle
    case triangle
}

class QRProcessor {
    // QR 코드 생성
    func generateQRCode(from type: QRCodeType, clearRatio: CGFloat, dotImage: UIImage?, foregroundColor: UIColor, backgroundColor: UIColor) -> UIImage? {
        guard let qrDataString = convertToQRDataString(from: type),
              let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        // 데이터 인코딩 (텍스트는 UTF-8, 나머지는 ASCII)
        let data: Data?
        switch type {
        case .text:
            data = qrDataString.data(using: .utf8) // .text인 경우 UTF-8
            print("UTF-8 인코딩 시도")
        default:
            data = qrDataString.data(using: .ascii) // 나머지 경우 ASCII
            print("ASCII 인코딩 시도")
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        // QR 코드에 색상 적용
        guard let coloredQRCode = applyColors(to: scaledImage, foregroundColor: foregroundColor, backgroundColor: backgroundColor) else { return nil }
        

        guard let clearedQRCode = clearCenterOfQRCode(qrCode: coloredQRCode, clearRatio: clearRatio, clearBackgroundColor: backgroundColor) else { return nil }


        return clearedQRCode
    }
    
    
    // QR 코드 색상 적용
    private func applyColors(to image: CIImage, foregroundColor: UIColor, backgroundColor: UIColor) -> UIImage? {
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setValue(image, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
        colorFilter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1")
        
        guard let outputImage = colorFilter.outputImage else { return nil }
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
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
        case .email(let email):
            return email
        }
    }
    
    // 중앙 비우기
    func clearCenterOfQRCode(qrCode: UIImage, clearRatio: CGFloat, clearBackgroundColor: UIColor) -> UIImage? {
        guard let cgImage = qrCode.cgImage else { return nil }
        
        let qrSize = CGSize(width: cgImage.width, height: cgImage.height)
        let clearSize = CGSize(width: qrSize.width * clearRatio, height: qrSize.height * clearRatio)
        let clearOrigin = CGPoint(x: (qrSize.width - clearSize.width) / 2, y: (qrSize.height - clearSize.height) / 2)
        
        UIGraphicsBeginImageContextWithOptions(qrSize, false, 0.0)
        qrCode.draw(in: CGRect(origin: .zero, size: qrSize))
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        //여기가 배경색인듯
        context.setFillColor(clearBackgroundColor.cgColor)
        context.fill(CGRect(origin: clearOrigin, size: clearSize))
        
        let clearedQRCode = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return clearedQRCode
    }
    
    // 도트 이미지 합성
    func overlayDotImageOnClearedQRCode(qrCode: UIImage, dotImage: UIImage, clearRatio: CGFloat, dotRatio: CGFloat, backgroundColor: UIColor) -> UIImage? {
        guard let clearedQRCode = clearCenterOfQRCode(qrCode: qrCode, clearRatio: clearRatio, clearBackgroundColor: backgroundColor) else { return nil }
        
        let qrSize = qrCode.size
        let clearSize = CGSize(width: qrSize.width * clearRatio, height: qrSize.height * clearRatio)
        let dotSize = CGSize(width: clearSize.width * dotRatio, height: clearSize.height * dotRatio)
        
        UIGraphicsBeginImageContextWithOptions(qrSize, false, 0.0)
        
        clearedQRCode.draw(in: CGRect(origin: .zero, size: qrSize))
        
        let dotOrigin = CGPoint(
            x: (qrSize.width - dotSize.width) / 2,
            y: (qrSize.height - dotSize.height) / 2
        )
    
        
        dotImage.draw(in: CGRect(origin: dotOrigin, size: dotSize))

        /*
        // 도트 이미지에 색상 적용
        let tintedDotImage = applyTintColor(to: dotImage, dotColor: dotColor, backgroundColor: backgroundColor)
        tintedDotImage?.draw(in: CGRect(origin: dotOrigin, size: dotSize))*/
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    
    // 도트 이미지 색상 변경
    private func applyTintColor(to image: UIImage, dotColor: UIColor, backgroundColor: UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = image.cgImage else { return nil }
        
        let rect = CGRect(origin: .zero, size: image.size)

          // 배경 색상 적용
          context.setFillColor(backgroundColor.cgColor)
          context.fill(rect)

          // 이미지 원래의 알파 채널(투명도)을 유지하면서 도트 색상 적용
          context.translateBy(x: 0, y: image.size.height)
          context.scaleBy(x: 1.0, y: -1.0)
          context.clip(to: rect, mask: cgImage)
          context.setFillColor(dotColor.cgColor)
          context.fill(rect)

          let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return tintedImage
      }
    
    // 이미지를 도트화
    func processImageToDots(image: UIImage, gridSize: Int, cellSize: Int, dotFore: CGColor, dotBack: CGColor) -> UIImage? {
        guard let binaryDots = convertImageToBinaryDotsEnhanced(image: image, gridSize: gridSize) else { return nil }
        return binaryDotsToImage(binaryDots: binaryDots, cellSize: cellSize, dotFore: dotFore, dotBack: dotBack)
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
    private func binaryDotsToImage(binaryDots: [[Int]], cellSize: Int, dotFore: CGColor, dotBack: CGColor) -> UIImage? {
        let rows = binaryDots.count
        let cols = binaryDots[0].count
        let imageSize = CGSize(width: cols * cellSize, height: rows * cellSize)
        
        UIGraphicsBeginImageContext(imageSize)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(dotBack)
        context.fill(CGRect(origin: .zero, size: imageSize))
        
        for y in 0..<rows {
            for x in 0..<cols {
                let rect = CGRect(
                    x: x * cellSize,
                    y: y * cellSize,
                    width: cellSize,
                    height: cellSize
                )
                context.setFillColor(binaryDots[y][x] == 1 ? dotFore : dotBack)
                context.fill(rect)
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

/*
class QRProcessor {
    // QR 코드 생성
    func generateQRCode(from type: QRCodeType, clearRatio: CGFloat, dotImage: UIImage?, eyeShape: QRCode.EyeShape, bodyShape: QRCode.PixelShape) -> UIImage? {
        guard let qrDataString = convertToQRDataString(from: type) else { return nil }
        
        // 데이터 인코딩 (텍스트는 UTF-8, 나머지는 ASCII)
        let data: Data?
        switch type {
        case .text:
            data = qrDataString.data(using: .utf8) // .text인 경우 UTF-8
            print("UTF-8 인코딩 시도")
        default:
            data = qrDataString.data(using: .ascii) // 나머지 경우 ASCII
            print("ASCII 인코딩 시도")
        }

        // QRCode 라이브러리를 사용해 기본 QR 코드 생성
        var qrCode = QRCode(data!)
    
        
        qrCode?.design.style.eye = eyeShape // Eye 모양 설정
        qrCode?.design.style.onPixels = bodyShape // Body 모양 설정

        
        // QR 코드 이미지 생성
        guard let qrImage = qrCode?.image(CGSize(width: 300, height: 300)) else { return nil }

        // 중앙 비우기
        guard let clearedQRCode = clearCenterOfQRCode(qrCode: qrImage, clearRatio: clearRatio) else { return nil }

        // 도트 이미지 합성
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
        case .email(let email):
            return "mailto:\(email)"
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
        let qrSize = qrCode.size
        let clearSize = CGSize(width: qrSize.width * clearRatio, height: qrSize.height * clearRatio)
        let dotSize = CGSize(width: clearSize.width * dotRatio, height: clearSize.height * dotRatio)

        UIGraphicsBeginImageContextWithOptions(qrSize, false, 0.0)
        qrCode.draw(in: CGRect(origin: .zero, size: qrSize))

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
}*/

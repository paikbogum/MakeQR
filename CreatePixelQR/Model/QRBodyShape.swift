//
//  QRBodyShape.swift
//  CreatePixelQR
//
//  Created by 백현진 on 3/13/25.
//

import Foundation
import QRCode
import QRCodeGenerator

enum QRBodyShape: CaseIterable {
    case data_circle
    case data_curvePixel
    case data_flower
    case data_horizontal
    case data_pointy
    case data_razor
    case data_roundedEndIndent
    case data_roundedPath
    case data_roundedRect
    case data_sharp
    case data_shiny
    case data_square
    case data_squircle
    case data_star
    case data_vertical
    
    /// 라이브러리의 실제 PixelShapeGenerator 인스턴스를 반환
    var bodyShape: any QRCodePixelShapeGenerator {
        switch self {
        case .data_circle:
            return QRCode.PixelShape.Circle()

        case .data_curvePixel:
            return QRCode.PixelShape.CurvePixel()

        case .data_flower:
            return QRCode.PixelShape.Flower()

        case .data_horizontal:
            return QRCode.PixelShape.Horizontal()

        case .data_pointy:
            return QRCode.PixelShape.Pointy()
            
        case .data_razor:
            return QRCode.PixelShape.Razor()
            
        case .data_roundedEndIndent:
            return QRCode.PixelShape.RoundedEndIndent()
            
        case .data_roundedPath:
            return QRCode.PixelShape.RoundedPath()
            
        case .data_roundedRect:
            return QRCode.PixelShape.RoundedRect()
            
        case .data_sharp:
            return QRCode.PixelShape.Sharp()
            
        case .data_shiny:
            return QRCode.PixelShape.Shiny()

        case .data_square:
            return QRCode.PixelShape.Square()
            
        case .data_squircle:
            return QRCode.PixelShape.Squircle()
            
        case .data_star:
            return QRCode.PixelShape.Star()

        case .data_vertical:
            return QRCode.PixelShape.Vertical()
        
        }
    }
}

//
//  QRBodyShape.swift
//  CreatePixelQR
//
//  Created by 백현진 on 3/13/25.
//

import Foundation
import QRCode
import QRCodeGenerator

enum QRBodyShape {
    case data_abstract
    case data_arrow
    case data_blob
    case data_circle
    case data_circuit
    case data_crt
    case data_curvePixel
    case data_diagonal
    case data_diamond
    case data_donut
    case data_flower
    case data_grid2x2
    case data_grid3x3
    case data_grid4x4
    case data_heart
    case data_hexagon
    case data_horizontal
    case data_koala
    case data_pointy
    case data_razor
    case data_roundedEndIndent
    case data_roundedPath
    case data_roundedRect
    case data_sharp
    case data_shiny
    case data_spikyCircle
    case data_square
    case data_squircle
    case data_star
    case data_stitch
    case data_vertical
    case data_vortex
    case data_wave
    case data_wex
    
    /// 라이브러리의 실제 PixelShapeGenerator 인스턴스를 반환
    var bodyShape: any QRCodePixelShapeGenerator {
        switch self {
            // case .data_abstract:
            // 가정: QRCode.PixelShape.Abstract()가 존재한다면
            ///    return QRCode.PixelShape.Abstract()
            // case .data_arrow:
            //    return QRCode.PixelShape.Arrow()
            // case .data_blob:
            //     return QRCode.PixelShape.Blob()
        case .data_circle:
            return QRCode.PixelShape.Circle()
            // case .data_circuit:
            //     return QRCode.PixelShape.Circuit()
            // case .data_crt:
            //    return QRCode.PixelShape.CRT()
        case .data_curvePixel:
            return QRCode.PixelShape.CurvePixel()
            // case .data_diagonal:
            //    return QRCode.PixelShape.Diagonal()
            // case .data_diamond:
            //     return QRCode.PixelShape.Diamond()
            // case .data_donut:
            //     return QRCode.PixelShape.Donut()
        case .data_flower:
            return QRCode.PixelShape.Flower()
            //  case .data_grid2x2:
            //      return QRCode.PixelShape.Grid2x2()
            //   case .data_grid3x3:
            //      return QRCode.PixelShape.Grid3x3()
            //   case .data_grid4x4:
            //    return QRCode.PixelShape.Grid4x4()
            // case .data_heart:
            //     return QRCode.PixelShape.Heart()
            // case .data_hexagon:
            //    return QRCode.PixelShape.Hexagon()
        case .data_horizontal:
            return QRCode.PixelShape.Horizontal()
            // case .data_koala:
            //    return QRCode.PixelShape.Koala()
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
            //  case .data_spikyCircle:
            //     return QRCode.PixelShape.SpikyCircle()
        case .data_square:
            return QRCode.PixelShape.Square()
        case .data_squircle:
            return QRCode.PixelShape.Squircle()
        case .data_star:
            return QRCode.PixelShape.Star()
            //case .data_stitch:
            //    return QRCode.PixelShape.Stitch()
        case .data_vertical:
            return QRCode.PixelShape.Vertical()
            // case .data_vortex:
            //    return QRCode.PixelShape.Vortex()
            // case .data_wave:
            //    return QRCode.PixelShape.Wave()
            // case .data_wex:
            //    return QRCode.PixelShape.Wex()
            // case .data_crt:
            //    return QRCode.PixelShape.CRT()
            
            
        default:
            return QRCode.PixelShape.Square()
        }
    }
}

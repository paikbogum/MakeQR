//
//  QREyeShape.swift
//  CreatePixelQR
//
//  Created by 백현진 on 3/11/25.
//

import Foundation
import QRCode
import QRCodeGenerator

enum QREyeShape {
    case eye_barsHorizontal
    case eye_barsVertical
    case eye_circle
    case eye_cloud
    case eye_corneredPixels
    case eye_crt
    case eye_dotDragHorizontal
    case eye_dotDragVertical
    case eye_edges
    case eye_explode
    case eye_eye
    case eye_fireball
    case eye_headlight
    case eye_leaf
    case eye_peacock
    case eye_pinch
    case eye_pixels
    case eye_roundedOuter
    case eye_roundedPointingIn
    case eye_roundedPointingOut
    case eye_roundedRect
    case eye_shield
    case eye_spikyCircle
    case eye_square
    case eye_squarePeg
    case eye_squircle
    case eye_surroundingBars
    case eye_teardrop
    case eye_ufo
    case eye_ufoRounded
    case eye_usePixelShape
    
    var eyeShape: any QRCodeEyeShapeGenerator {
        switch self {
        case .eye_barsHorizontal:
            return QRCode.EyeShape.BarsHorizontal()
        case .eye_barsVertical:
            return QRCode.EyeShape.BarsVertical()
        case .eye_circle:
            return QRCode.EyeShape.Circle()
       // case .eye_cloud:
        //    return QRCode.EyeShape.Cloud()
        case .eye_corneredPixels:
            return QRCode.EyeShape.CorneredPixels()
       // case .eye_crt:
        //    return QRCode.EyeShape.CRT()
     //   case .eye_dotDragHorizontal:
      //      return QRCode.EyeShape.DotDragHorizontal()
     //   case .eye_dotDragVertical:
      //      return QRCode.EyeShape.DotDragVertical()
        case .eye_edges:
            return QRCode.EyeShape.Edges()
       // case .eye_explode:
        //    return QRCode.EyeShape.Explode()
       // case .eye_eye:
        //    return QRCode.EyeShape.Eye()
        case .eye_fireball:
            return QRCode.EyeShape.Fireball()
      //  case .eye_headlight:
       //     return QRCode.EyeShape.Headlight()
        case .eye_leaf:
            return QRCode.EyeShape.Leaf()
        case .eye_peacock:
            return QRCode.EyeShape.Peacock()
        case .eye_pinch:
            return QRCode.EyeShape.Pinch()
        case .eye_pixels:
            return QRCode.EyeShape.Pixels()
        case .eye_roundedOuter:
            return QRCode.EyeShape.RoundedOuter()
        case .eye_roundedPointingIn:
            return QRCode.EyeShape.RoundedPointingIn()
        case .eye_roundedPointingOut:
            return QRCode.EyeShape.RoundedPointingOut()
        case .eye_roundedRect:
            return QRCode.EyeShape.RoundedRect()
        case .eye_shield:
            return QRCode.EyeShape.Shield()
       // case .eye_spikyCircle:
        //    return QRCode.EyeShape.SpikyCircle()
        case .eye_square:
            return QRCode.EyeShape.Square()
      //  case .eye_squarePeg:
       //     return QRCode.EyeShape.SquarePeg()
        case .eye_squircle:
            return QRCode.EyeShape.Squircle()
     //   case .eye_surroundingBars:
     //       return QRCode.EyeShape.SurroundingBars()
        case .eye_teardrop:
            return QRCode.EyeShape.Teardrop()
        case .eye_ufo:
            return QRCode.EyeShape.UFO()
    //    case .eye_ufoRounded:
     //       return QRCode.EyeShape.UFORounded()
        case .eye_usePixelShape:
            return QRCode.EyeShape.UsePixelShape()
            
        default:
            return QRCode.EyeShape.Square()
        }
    }
}

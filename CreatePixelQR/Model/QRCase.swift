//
//  QRCase.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/1/24.
//

import Foundation


enum QRCase {
    case url
    case wifi
    case text
    
    
    var categoryCase: String {
        switch self {
        case .url:
            return "url"
            
        case .wifi:
            return "wifi"
            
        case .text:
            return "text"
            
        }
    }
}

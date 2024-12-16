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
    case phone
    
    
    var categoryCase: String {
        switch self {
        case .url:
            return "URL"
            
        case .wifi:
            return "WIFI"
            
        case .text:
            return "TEXT"
        
        case .phone:
            return "PHONE"
            
        }
    }
}

enum QRCodeType {
    case url(String)
    case wifi(ssid: String, password: String, security: String, hidden: Bool)
    case phone(String)
    case text(String)
}

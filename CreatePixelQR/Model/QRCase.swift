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
    case email
    
    
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
            
        case .email:
            return "EMAIL"
        
        }
    }
}

enum QRCodeType {
    case url(String)
    case wifi(ssid: String, password: String, security: String, hidden: Bool)
    case phone(String)
    case text(String)
    case email(String)
}

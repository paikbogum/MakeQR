//
//  QRHistory.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/18/24.
//

import Foundation

struct QRHistory: Codable {
    let id: UUID // 고유 식별자
    let type: QRType // QR 종류 (URL, Text, Wi-Fi 등)
    let content: String // QR 데이터 내용
    let action: QRAction // QR 생성 또는 스캔 여부
    let date: Date // 생성 또는 스캔 날짜
}

enum QRType: String, Codable {
    case url = "URL"
    case text = "Text"
    case wifi = "Wi-Fi"
    case phone = "Phone"
}

enum QRAction: String, Codable {
    case generated = "Generated" // QR 생성
    case scanned = "Scanned" // QR 스캔
}

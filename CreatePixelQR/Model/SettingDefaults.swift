//
//  SettingDefaults.swift
//  CreatePixelQR
//
//  Created by 백현진 on 2/1/25.
//

import UIKit


struct HistoryUserSetting {
    static let saveGeneratedQRHistory = "saveGeneratedQRHistory" // QR 생성 기록 자동 저장 여부
    static let saveScannedQRHistory = "saveScannedQRHistory" // QR 스캔 기록 자동 저장 여부
}

struct UserSettings {
    static let enableVibrationOnScan = "enableVibrationOnScan" // QR 탐지 시 진동 여부
    static let useRearCamera = "useRearCamera"  // 후면 카메라 사용 여부
}

struct QRDefaults {
    static let qrForegroundColor = "qrForegroundColor"  // QR 전경색
    static let qrBackgroundColor = "qrBackgroundColor"  // QR 배경색
    static let qrLogoColor = "qrLogoColor"  // QR 로고 색상
    static let qrDamageCorrection = "qrDamageCorrection"  // QR 손상율
    static let qrLogoDotSharpness = "qrLogoDotSharpness"  // QR 로고 도트 선명도
}

//
//  QRHistoryManager.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/18/24.
//

import Foundation

class QRHistoryManager {
    static let shared = QRHistoryManager()
    private let historyKey = "QRHistory"

    // 히스토리 저장
    func saveHistory(item: QRHistory) {
        var history = loadHistory()
        history.append(item)

        if let encodedData = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encodedData, forKey: historyKey)
        }
    }

    // 히스토리 로드
    func loadHistory() -> [QRHistory] {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let history = try? JSONDecoder().decode([QRHistory].self, from: data) else {
            return []
        }
        return history
    }

    // 히스토리 삭제 (인덱스 기준)
    func deleteHistory(at index: Int) {
        var history = loadHistory()
        guard index >= 0 && index < history.count else { return }

        history.remove(at: index)

        if let encodedData = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encodedData, forKey: historyKey)
        }
    }

    // 히스토리 전체 삭제
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
}

extension QRHistoryManager {
    
    /// QR 생성 기록 자동 저장 설정 확인
    private func shouldSaveGeneratedHistory() -> Bool {
        return UserDefaults.standard.bool(forKey: HistoryUserSetting.saveGeneratedQRHistory)
    }

    /// QR 스캔 기록 자동 저장 설정 확인
    private func shouldSaveScannedHistory() -> Bool {
        return UserDefaults.standard.bool(forKey: HistoryUserSetting.saveScannedQRHistory)
    }
    
    // URL 저장
    func saveURLHistory(url: String, act: QRAction) {
        guard (act == .generated && shouldSaveGeneratedHistory()) || (act == .scanned && shouldSaveScannedHistory()) else {
            return
        }
        
        let newHistory = QRHistory(
            id: UUID(),
            type: .url,
            content: url,
            action: act,
            date: Date()
        )
        saveHistory(item: newHistory)
        print("URL 히스토리가 저장되었습니다: \(url)")
    }

    // 텍스트 저장
    func saveTextHistory(text: String, act: QRAction) {
        guard (act == .generated && shouldSaveGeneratedHistory()) || (act == .scanned && shouldSaveScannedHistory()) else {
            return
        }
        
        let newHistory = QRHistory(
            id: UUID(),
            type: .text,
            content: text,
            action: act,
            date: Date()
        )
        saveHistory(item: newHistory)
        print("텍스트 히스토리가 저장되었습니다: \(text)")
    }

    // Wi-Fi 저장
    func saveWiFiHistory(ssid: String, password: String, security: String, isHidden: Bool, act: QRAction) {
        
        guard (act == .generated && shouldSaveGeneratedHistory()) || (act == .scanned && shouldSaveScannedHistory()) else {
            return
        }
        
        let hiddenValue = isHidden ? "1" : "0"
        let wifiContent = "WIFI:S:\(ssid);T:\(security);P:\(password);H:\(hiddenValue);;"

        let newHistory = QRHistory(
            id: UUID(),
            type: .wifi,
            content: wifiContent,
            action: act,
            date: Date()
        )
        saveHistory(item: newHistory)
        print("Wi-Fi 히스토리가 저장되었습니다: \(wifiContent)")
    }

    // 전화번호 저장
    func savePhoneHistory(phoneNumber: String, act: QRAction) {
        guard (act == .generated && shouldSaveGeneratedHistory()) || (act == .scanned && shouldSaveScannedHistory()) else {
            return
        }
        
        let newHistory = QRHistory(
            id: UUID(),
            type: .phone,
            content: phoneNumber,
            action: act,
            date: Date()
        )
        saveHistory(item: newHistory)
        print("전화번호 히스토리가 저장되었습니다: \(phoneNumber)")
    }
    
    // 전화번호 저장
    func saveEmailHistory(email: String, act: QRAction) {
        guard (act == .generated && shouldSaveGeneratedHistory()) || (act == .scanned && shouldSaveScannedHistory()) else {
            return
        }
        
        let newHistory = QRHistory(
            id: UUID(),
            type: .email,
            content: email,
            action: act,
            date: Date()
        )
        saveHistory(item: newHistory)
        print("이메일 히스토리가 저장되었습니다: \(email)")
    }
}

extension QRHistoryManager {
    // URL 히스토리 로드
    func loadURLHistory() -> [QRHistory] {
        return loadHistory().filter { $0.type == .url }
    }

    // 텍스트 히스토리 로드
    func loadTextHistory() -> [QRHistory] {
        return loadHistory().filter { $0.type == .text }
    }

    // Wi-Fi 히스토리 로드
    func loadWiFiHistory() -> [QRHistory] {
        return loadHistory().filter { $0.type == .wifi }
    }

    // 전화번호 히스토리 로드
    func loadPhoneHistory() -> [QRHistory] {
        return loadHistory().filter { $0.type == .phone }
    }
    // 이메일 히스토리 로드
    func loadEmailHistory() -> [QRHistory] {
        return loadHistory().filter { $0.type == .email }
    }
}


extension QRHistoryManager {
    // 특정 URL 히스토리 삭제
    func deleteURLHistory(at index: Int) {
        let urlHistory = loadURLHistory()
        guard index >= 0 && index < urlHistory.count else { return }

        let targetItem = urlHistory[index]
        deleteSpecificHistory(by: targetItem.id)
    }

    // 특정 텍스트 히스토리 삭제
    func deleteTextHistory(at index: Int) {
        let textHistory = loadTextHistory()
        guard index >= 0 && index < textHistory.count else { return }

        let targetItem = textHistory[index]
        deleteSpecificHistory(by: targetItem.id)
    }

    // 특정 Wi-Fi 히스토리 삭제
    func deleteWiFiHistory(at index: Int) {
        let wifiHistory = loadWiFiHistory()
        guard index >= 0 && index < wifiHistory.count else { return }

        let targetItem = wifiHistory[index]
        deleteSpecificHistory(by: targetItem.id)
    }

    // 특정 전화번호 히스토리 삭제
    func deletePhoneHistory(at index: Int) {
        let phoneHistory = loadPhoneHistory()
        guard index >= 0 && index < phoneHistory.count else { return }

        let targetItem = phoneHistory[index]
        deleteSpecificHistory(by: targetItem.id)
    }

    // 특정 히스토리 삭제 (ID 기반)
    func deleteSpecificHistory(by id: UUID) {
        var allHistory = loadHistory()
        allHistory.removeAll { $0.id == id }

        if let encodedData = try? JSONEncoder().encode(allHistory) {
            UserDefaults.standard.set(encodedData, forKey: historyKey)
        }
    }
}

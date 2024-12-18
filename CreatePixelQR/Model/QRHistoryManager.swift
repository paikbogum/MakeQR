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

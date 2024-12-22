//
//  HistoryView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/18/24.
//

import UIKit

class HistoryView: UIView {
    
    @IBOutlet weak var caseSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
    func historySetting() {
        historyTableView.backgroundColor = .clear
    
    }
    
    
}

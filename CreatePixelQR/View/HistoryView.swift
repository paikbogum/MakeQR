//
//  HistoryView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/18/24.
//

import UIKit

class HistoryView: UIView {
    
    @IBOutlet weak var caseSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var filterButton: UIButton!
    
    func historySetting() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        filterButton.tintColor = CustomColor.backgroundColor.color
        
        topButton.tintColor = CustomColor.backgroundColor.color
        topLabel.textColor = CustomColor.backgroundColor.color
        topLabel.font = UIFont.boldSystemFont(ofSize: 20)
        topLabel.text = "기록"
        
        historyTableView.backgroundColor = .clear
    }
    
    
}

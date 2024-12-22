//
//  HistoryTableViewCell.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/18/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingCells()
    }
    
    private func settingCells() {
        
        contentView.backgroundColor = .white
        
        typeLabel.textColor = .black
        mainLabel.textColor = .black
        dateLabel.textColor = .black
        
        
        typeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        mainLabel.font = UIFont.boldSystemFont(ofSize: 12)
        dateLabel.font = UIFont.boldSystemFont(ofSize: 10)
        
        mainLabel.numberOfLines = 0
    }
}

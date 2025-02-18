//
//  InfoTableViewCell.swift
//  CreatePixelQR
//
//  Created by 백현진 on 2/18/25.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        
    }
    
    private func setUI() {
        infoLabel.font = UIFont.boldSystemFont(ofSize: 15)
        infoLabel.textColor = .white
        infoButton.tintColor = .white
        infoButton.isUserInteractionEnabled = false
        
        contentView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        
    }

    
}

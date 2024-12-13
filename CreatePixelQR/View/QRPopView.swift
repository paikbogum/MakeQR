//
//  QRPopView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/13/24.
//

import UIKit

class QRPopView: UIView {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var resultTypeLabel: UILabel!
    
    func setUI() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color

        containerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        resultTypeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        resultTypeLabel.textColor = .gray
        
        resultLabel.font = UIFont.boldSystemFont(ofSize: 15)
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.textColor = CustomColor.backgroundColor.color
        
    }
}

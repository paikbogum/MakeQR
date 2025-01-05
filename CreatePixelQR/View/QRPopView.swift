//
//  QRPopView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/13/24.
//

import UIKit

class QRPopView: UIView {
    @IBOutlet weak var topSmallUIVIew: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var resultTypeLabel: UILabel!
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var copyButton: UIButton!
    
    func setUI() {
        
        topSmallUIVIew.backgroundColor = .lightGray
        topSmallUIVIew.layer.cornerRadius = 4
        
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        containerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        resultTypeLabel.font = UIFont.boldSystemFont(ofSize: 17)
        resultTypeLabel.textColor = .lightGray
        
        resultLabel.font = UIFont.boldSystemFont(ofSize: 15)
        resultLabel.numberOfLines = 0
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.textColor = CustomColor.backgroundColor.color
        
        linkButton.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        linkButton.layer.cornerRadius = 8
        
        linkButton.tintColor = CustomColor.backgroundColor.color
        
        copyButton.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        copyButton.tintColor = CustomColor.backgroundColor.color
        copyButton.layer.cornerRadius = 8
    }
    
        func applyUnderline(to label: UILabel, text: String) {
            let attributedString = NSAttributedString(
                string: text,
                attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            label.attributedText = attributedString
        }
    }


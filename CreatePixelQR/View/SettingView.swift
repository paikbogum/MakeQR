//
//  SettingView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/31/24.
//

import UIKit

class SettingView: UIView {
    
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    func setUI() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        topButton.tintColor = CustomColor.backgroundColor.color
        topLabel.textColor = CustomColor.backgroundColor.color
        topLabel.font = UIFont.boldSystemFont(ofSize: 20)
        topLabel.text = "환경설정"
        
        containerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        
    }
}

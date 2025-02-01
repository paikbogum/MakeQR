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
    
    @IBOutlet weak var vibrateLabel: UILabel!
    @IBOutlet weak var vibrateSwitch: UISwitch!
    
    @IBOutlet weak var detectHistoryLabel: UILabel!

    @IBOutlet weak var detectHistorySwitch: UISwitch!
  
    @IBOutlet weak var makeHistoryLabel: UILabel!
    
    @IBOutlet weak var makeHistorySwitch: UISwitch!
    
    @IBOutlet weak var backCameraLabel: UILabel!
    
    @IBOutlet weak var backCameraSwitch: UISwitch!
    
    @IBOutlet weak var customizingQRButton: UIButton!
    
    @IBOutlet weak var customizingQRButton2: UIButton!
    
    
    func setUI() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        topButton.tintColor = CustomColor.backgroundColor.color
        topLabel.textColor = CustomColor.backgroundColor.color
        topLabel.font = UIFont.boldSystemFont(ofSize: 20)
        topLabel.text = "환경설정"
        
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
    
        vibrateLabel.text = "감지 진동"
        vibrateLabel.textColor = CustomColor.backgroundColor.color
        vibrateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        vibrateSwitch.tintColor = CustomColor.backgroundColor.color
        vibrateSwitch.onTintColor = CustomColor.caldendarFontColor.color
        
        detectHistoryLabel.text = "감지 QR 기록 저장"
        detectHistoryLabel.textColor = CustomColor.backgroundColor.color
        detectHistoryLabel.font = UIFont.boldSystemFont(ofSize: 17)
    
        
        detectHistorySwitch.tintColor = CustomColor.backgroundColor.color
        detectHistorySwitch.onTintColor = CustomColor.caldendarFontColor.color
        
        makeHistoryLabel.text = "제작 QR 기록 저장"
        makeHistoryLabel.textColor = CustomColor.backgroundColor.color
        makeHistoryLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        makeHistorySwitch.tintColor = CustomColor.backgroundColor.color
        makeHistorySwitch.onTintColor = CustomColor.caldendarFontColor.color
        
        backCameraLabel.text = "후면 카메라 사용"
        backCameraLabel.textColor = CustomColor.backgroundColor.color
        backCameraLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        backCameraSwitch.tintColor = CustomColor.backgroundColor.color
        backCameraSwitch.onTintColor = CustomColor.caldendarFontColor.color
        
        customizingQRButton.setTitle("QR 사용자 설정", for: .normal)
        customizingQRButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        customizingQRButton.tintColor = CustomColor.backgroundColor.color
        
        customizingQRButton.backgroundColor = .clear
        
        customizingQRButton2.tintColor = CustomColor.backgroundColor.color
        
    }
}

//
//  CustomizingView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 1/6/25.
//

import UIKit

class CustomizingView: UIView {
    
    @IBOutlet weak var colorSetView: UIView!
    @IBOutlet weak var colorSetButton: UIButton!
    
    @IBOutlet weak var colorSetLabel: UILabel!
    
    @IBOutlet weak var color1Label: UILabel!
    
    @IBOutlet weak var color1Button: UIButton!
    
    @IBOutlet weak var color2Label: UILabel!
    
    @IBOutlet weak var color2Button: UIButton!
    
    @IBOutlet weak var color3Label: UILabel!
    
    @IBOutlet weak var color3Button: UIButton!
    
    @IBOutlet weak var qrSetButton: UIButton!
    
    @IBOutlet weak var qrSetLabel: UILabel!
    
    @IBOutlet weak var qrSetView: UIView!
    
    @IBOutlet weak var qrLabel: UILabel!
    
    @IBOutlet weak var qrSetValueLabel: UILabel!
    @IBOutlet weak var qrSetSlider: UISlider!
    
    @IBOutlet weak var qrSetValueMin: UILabel!
    
    @IBOutlet weak var qrSetValueMax: UILabel!
    
    @IBOutlet weak var logoSetButton: UIButton!
    
    @IBOutlet weak var logoSetLabel: UILabel!
    
    @IBOutlet weak var logoSetView: UIView!
    
    @IBOutlet weak var logoDotLabel: UILabel!
    
    @IBOutlet weak var logoDotSlider: UISlider!
    
    @IBOutlet weak var logoDotValueLabel: UILabel!
    
    @IBOutlet weak var logoValueMin: UILabel!
    
    @IBOutlet weak var logoValueMax: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var qrsizeButton: UIButton!
    
    @IBOutlet weak var qrsizeLabel: UILabel!

    
    @IBOutlet weak var qrsizeTF: UITextField!
    
    
    func setColorSetUI() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        colorSetView.layer.cornerRadius = 8
        colorSetView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        colorSetLabel.text = "QR코드 색상"
        colorSetLabel.font = UIFont.boldSystemFont(ofSize: 15)
        colorSetLabel.textColor = CustomColor.backgroundColor.color
        
        colorSetButton.tintColor = CustomColor.backgroundColor.color
        
        color1Label.font = UIFont.boldSystemFont(ofSize: 13)
        color1Label.textColor = CustomColor.backgroundColor.color
        color1Label.text = "전경색 선택"
        
        color1Button.layer.cornerRadius = 4
        color2Button.layer.cornerRadius = 4
        color3Button.layer.cornerRadius = 4
        
        color2Label.font = UIFont.boldSystemFont(ofSize: 13)
        color2Label.textColor = CustomColor.backgroundColor.color
        color2Label.text = "배경색 선택"
        
        color3Label.font = UIFont.boldSystemFont(ofSize: 13)
        color3Label.textColor = CustomColor.backgroundColor.color
        color3Label.text = "로고색 선택"
    }
    
    func setLogoSetUI() {
        logoSetView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        logoSetView.layer.cornerRadius = 8
        logoSetButton.tintColor = CustomColor.backgroundColor.color
        logoSetLabel.textColor = CustomColor.backgroundColor.color
        logoSetLabel.text = "QR 로고"
        logoSetLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        logoDotLabel.text = "로고 도트 선명도:"
        logoDotLabel.font = UIFont.boldSystemFont(ofSize: 13)
        logoDotLabel.textColor = CustomColor.backgroundColor.color
        
        logoDotSlider.tintColor = CustomColor.backgroundColor.color
        logoDotSlider.minimumValue = 5
        logoDotSlider.maximumValue = 20
        
        logoValueMax.text = String(Int(logoDotSlider.maximumValue)) + "X"
        logoValueMax.textColor = CustomColor.backgroundColor.color
        logoValueMin.textColor = CustomColor.backgroundColor.color
        
        logoValueMin.text = String(Int(logoDotSlider.minimumValue)) + "X"
        logoValueMax.font = UIFont.boldSystemFont(ofSize: 10)
        logoValueMin.font = UIFont.boldSystemFont(ofSize: 10)
        
        logoDotValueLabel.font = UIFont.boldSystemFont(ofSize: 14)
        logoDotValueLabel.textColor = .white
    }
    
    func setQrSetUI() {
        qrSetView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        qrSetView.layer.cornerRadius = 8
        qrSetButton.tintColor = CustomColor.backgroundColor.color
        qrSetLabel.textColor = CustomColor.backgroundColor.color
        qrSetLabel.text = "QR 손상률"
        qrSetLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        qrLabel.text = "QR 손상률:"
        qrLabel.font = UIFont.boldSystemFont(ofSize: 13)
        qrLabel.textColor = CustomColor.backgroundColor.color
        
        qrSetSlider.tintColor = CustomColor.backgroundColor.color
        qrSetSlider.minimumValue = 0.05
        qrSetSlider.maximumValue = 0.3
        //qrSetSlider.value = 0.3
        
        qrSetValueMax.text = String(Int(qrSetSlider.maximumValue * 100)) + "%"
        qrSetValueMax.textColor = CustomColor.backgroundColor.color
        qrSetValueMin.textColor = CustomColor.backgroundColor.color
        
        qrSetValueMin.text = String(Int(qrSetSlider.minimumValue * 100)) + "%"
        qrSetValueMax.font = UIFont.boldSystemFont(ofSize: 10)
        qrSetValueMin.font = UIFont.boldSystemFont(ofSize: 10)
        
        qrSetValueLabel.font = UIFont.boldSystemFont(ofSize: 14)
        //qrSetValueLabel.text = String(Int(qrSetSlider.value * 100)) + "%"
        qrSetValueLabel.textColor = .white
        
        submitButton.tintColor = CustomColor.backgroundColor.color
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 8
        submitButton.setTitle("저장", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func setQRsizeUI() {
        qrsizeButton.tintColor = CustomColor.backgroundColor.color
        qrsizeLabel.textColor = CustomColor.backgroundColor.color
        
        qrsizeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        qrsizeLabel.text = "QR 사이즈"

        
        qrsizeTF.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        
        
        qrsizeTF.textColor = CustomColor
            .backgroundColor.color
    }
    
}

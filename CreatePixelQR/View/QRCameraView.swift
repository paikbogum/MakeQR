//
//  QRCameraView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/13/24.
//

import UIKit

class QRCameraView: UIView {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    func setUI() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        infoLabel.textColor = .lightGray
        infoLabel.text = "QR코드를 화면 중앙에 맞춰주세요"
        infoLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
    }
}

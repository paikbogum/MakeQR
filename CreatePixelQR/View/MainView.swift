//
//  MainView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit

class MainView: UIView {
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContainerLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainLabelTopConstraint: NSLayoutConstraint!
    
    func mainViewUISetting() {
        topContainerView.layer.cornerRadius = 8
        topContainerView.clipsToBounds = true
        
        mainCollectionView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        topContainerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        topContainerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        topContainerLabel.textColor = .white
        topContainerLabel.text = "나만의 QR코드를 만들어보세요!"
        
    }
}

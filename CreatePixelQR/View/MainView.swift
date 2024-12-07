//
//  MainView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit

class MainView: UIView {
    
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var topContainerLabel: UILabel!
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    @IBOutlet weak var topContainerImageView: UIImageView!
    
    func mainViewUISetting() {
        topContainerView.layer.cornerRadius = 8
        topContainerView.clipsToBounds = true
        
        mainContainerView.layer.cornerRadius = 8
        mainContainerView.clipsToBounds = true
        mainCollectionView.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        topContainerView.backgroundColor = .white
        topContainerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        topContainerLabel.textColor = .black
        
        topContainerLabel.text = "나만의 QR코드를 만들어보세요!"
        
        topContainerImageView.image = UIImage(named: "download")
        
    }
}

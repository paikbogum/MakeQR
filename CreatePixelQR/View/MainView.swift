//
//  MainView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit

class MainView: UIView {
    
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var exQRImageView: UIImageView!
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContainerLabel: UILabel!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!

    @IBOutlet weak var makeQRButton: UIButton!

    @IBOutlet weak var bottomContainerViewTopSafeContraint: NSLayoutConstraint!
    
    func mainViewUISetting() {
        topContainerView.layer.cornerRadius = 16
        topContainerView.clipsToBounds = true
        
        topButton.tintColor = CustomColor.backgroundColor.color
        topLabel.font = UIFont.boldSystemFont(ofSize: 20)
        topLabel.textColor = CustomColor.backgroundColor.color
        topLabel.text = "QR 만들기"
        
        mainCollectionView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        mainCollectionView.alpha = 0
        
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        topContainerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        topContainerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        topContainerLabel.textColor = .white
        topContainerLabel.text = "나만의 QR코드를 만들어보세요!"
        
        exQRImageView.image = UIImage(named: "QREx")
        
        makeQRButton.setTitle("QR코드 생성", for: .normal)
        makeQRButton.backgroundColor = .darkGray
        makeQRButton.titleLabel?.textColor = .white
        makeQRButton.layer.cornerRadius = 8

        makeQRButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        mainCollectionView.isHidden = true
        
        bottomContainerView.clipsToBounds = true
        bottomContainerView.layer.cornerRadius = 16
        bottomContainerView.backgroundColor = .clear
        
        bottomContainerViewTopSafeContraint.constant = 300
        
    }
}

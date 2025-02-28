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
        
        //topContainerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        topContainerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color

        exQRImageView.image = UIImage(named: "mainViewQR")
        
        makeQRButton.setTitle("QR코드 생성", for: .normal)
        makeQRButton.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        makeQRButton.titleLabel?.textColor = .white
        makeQRButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        makeQRButton.layer.cornerRadius = 4
        makeQRButton.layer.borderWidth = 1.0
        makeQRButton.layer.borderColor = CustomColor.backgroundColor.color.cgColor
        
        mainCollectionView.isHidden = true
        
        bottomContainerView.clipsToBounds = true
        bottomContainerView.layer.cornerRadius = 16
        bottomContainerView.backgroundColor = .clear
        
        bottomContainerViewTopSafeContraint.constant = 300
        bottomContainerView.isHidden = true
    }
}

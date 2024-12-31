//
//  MakeWifiView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/5/24.
//

import UIKit

class MakeWifiView: UIView {
    
    @IBOutlet weak var makeQRContainerView: UIView!
    
    
    @IBOutlet weak var wifiNameLabel: UILabel!
    
    @IBOutlet weak var wifiPasswordLabel: UILabel!
    @IBOutlet weak var wifiSecurityLabel: UILabel!
    
    @IBOutlet weak var wifiHiddenLabel: UILabel!
    
    @IBOutlet weak var wifiNameTF: UITextField!
    
    @IBOutlet weak var wifiPasswordTF: UITextField!
    
    @IBOutlet weak var wifiSecurityTypeTF: UITextField!
    
    @IBOutlet weak var wifiHiddenTF: UITextField!
    
    @IBOutlet weak var firstUIView: UIView!
    
    @IBOutlet weak var firstStepButton: UIButton!
    
    @IBOutlet weak var firstStepLabel: UILabel!
    
    @IBOutlet weak var secondUIView: UIView!
    
    @IBOutlet weak var secondStepButton: UIButton!
    
    @IBOutlet weak var secondStepLabel: UILabel!
    
    @IBOutlet weak var qrPreviewImageView: UIImageView!
    
    @IBOutlet weak var selectImageButton: UIButton!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    func MakeQRViewUISetting() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        makeQRContainerView.layer.cornerRadius = 8
        makeQRContainerView.clipsToBounds = true
        makeQRContainerView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        
        firstUIView.backgroundColor = .white
        firstUIView.layer.cornerRadius = 8
        firstUIView.clipsToBounds = true
        firstUIView.layer.borderWidth = 2.0
        firstUIView.layer.borderColor = UIColor.green.cgColor

        firstStepLabel.text = "QR코드에 합성할 이미지를 선택하세요"
        firstStepLabel.font = UIFont.boldSystemFont(ofSize: 15)
        firstStepLabel.textColor = .gray
        
        firstStepButton.tintColor = .gray
        firstStepButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        secondUIView.backgroundColor = .white
        secondUIView.layer.cornerRadius = 8
        secondUIView.clipsToBounds = true
        secondUIView.layer.borderWidth = 2.0
        secondUIView.layer.borderColor = UIColor.white.cgColor
        
        secondStepLabel.text = "생성할 QR코드의 Wi-Fi정보를 입력해주세요"
        secondStepLabel.font = UIFont.boldSystemFont(ofSize: 15)
        secondStepLabel.textColor = .gray
        secondStepButton.tintColor = .gray
        secondStepButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        selectImageButton.setTitle("이미지 추가", for: .normal)
        selectImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        selectImageButton.tintColor = .white
        selectImageButton.layer.cornerRadius = 8
        selectImageButton.clipsToBounds = true
        selectImageButton.backgroundColor = .lightGray
        
        /*
        urlTF.font = UIFont.boldSystemFont(ofSize: 15)
        urlTF.textColor = .darkGray
        urlTF.backgroundColor = .white
        urlTF.layer.cornerRadius = 4
        urlTF.layer.borderColor = UIColor.gray.cgColor
        urlTF.layer.borderWidth = 0.5*/
        
        createButton.setTitle("STEP 1", for: .normal)
        createButton.tintColor = .white
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        createButton.clipsToBounds = true
        createButton.layer.cornerRadius = 8
        
        plusButton.tintColor = .lightGray
        plusButton.isUserInteractionEnabled = false
        
        secondUIView.isHidden = true
    
        wifiNameLabel.font = UIFont.boldSystemFont(ofSize: 12)
        wifiNameLabel.textColor = .gray
        
        wifiPasswordLabel.font = UIFont.boldSystemFont(ofSize: 12)
        wifiPasswordLabel.textColor = .gray
         
        wifiSecurityLabel.font = UIFont.boldSystemFont(ofSize: 12)
        wifiSecurityLabel.textColor = .gray
        
        wifiHiddenLabel.font = UIFont.boldSystemFont(ofSize: 12)
        wifiHiddenLabel.textColor = .gray
        wifiHiddenTF.text = "공개"
        
        
        wifiNameTF.font = UIFont.boldSystemFont(ofSize: 15)
        wifiNameTF.textColor = .darkGray
        wifiNameTF.backgroundColor = .white
        wifiNameTF.layer.cornerRadius = 4
        wifiNameTF.layer.borderColor = UIColor.gray.cgColor
        wifiNameTF.layer.borderWidth = 0.5
        wifiNameTF.returnKeyType = .done
        
        wifiSecurityTypeTF.font = UIFont.boldSystemFont(ofSize: 15)
        wifiSecurityTypeTF.textColor = .darkGray
        wifiSecurityTypeTF.backgroundColor = .white
        wifiSecurityTypeTF.layer.cornerRadius = 4
        wifiSecurityTypeTF.layer.borderColor = UIColor.gray.cgColor
        wifiSecurityTypeTF.layer.borderWidth = 0.5
        wifiSecurityTypeTF.returnKeyType = .done
        
        wifiPasswordTF.font = UIFont.boldSystemFont(ofSize: 15)
        wifiPasswordTF.textColor = .darkGray
        wifiPasswordTF.backgroundColor = .white
        wifiPasswordTF.layer.cornerRadius = 4
        wifiPasswordTF.layer.borderColor = UIColor.gray.cgColor
        wifiPasswordTF.layer.borderWidth = 0.5
        wifiPasswordTF.returnKeyType = .done
        
        wifiHiddenTF.font = UIFont.boldSystemFont(ofSize: 15)
        wifiHiddenTF.textColor = .darkGray
        wifiHiddenTF.backgroundColor = .white
        wifiHiddenTF.layer.cornerRadius = 4
        wifiHiddenTF.layer.borderColor = UIColor.gray.cgColor
        wifiHiddenTF.layer.borderWidth = 0.5
        wifiHiddenTF.returnKeyType = .done
    }
}

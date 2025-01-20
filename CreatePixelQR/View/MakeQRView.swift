//
//  MakeQRView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit
import Lottie
import SnapKit


class MakeQRView: UIView {
    
    @IBOutlet weak var makeQRContainerView: UIView!
    
    @IBOutlet weak var firstUIView: UIView!
    
    @IBOutlet weak var firstStepLabel: UILabel!
    
    @IBOutlet weak var firstStepButton: UIButton!
    
    @IBOutlet weak var secondUIView: UIView!
    
    @IBOutlet weak var secondStepLabel: UILabel!
    
    @IBOutlet weak var secondStepButton: UIButton!
    
    @IBOutlet weak var qrPreviewImageView: UIImageView!
    
    @IBOutlet weak var seletedImageView: UIImageView!
    
    @IBOutlet weak var selectImageButton: UIButton!
    
    @IBOutlet weak var urlTF: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var customQRButton: UIButton!
    
    var animationView: LottieAnimationView?
    var loadingLabel: UILabel?
    
    func MakeQRViewUISetting() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        makeQRContainerView.layer.cornerRadius = 8
        makeQRContainerView.clipsToBounds = true
        makeQRContainerView.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        firstUIView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        firstUIView.layer.cornerRadius = 8
        firstUIView.clipsToBounds = true
        firstUIView.layer.borderWidth = 2.0
        firstUIView.layer.borderColor = UIColor.green.cgColor
        
        firstStepLabel.text = "QR코드에 합성할 이미지를 선택하세요"
        firstStepLabel.font = UIFont.boldSystemFont(ofSize: 15)
        firstStepLabel.textColor = .gray
        
        firstStepButton.tintColor = .gray
        firstStepButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        secondUIView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        secondUIView.layer.cornerRadius = 8
        secondUIView.clipsToBounds = true
        secondUIView.layer.borderWidth = 2.0
        secondUIView.layer.borderColor = CustomColor.darkModeDarkGrayColor.color.cgColor
        
        secondStepLabel.text = "생성할 QR코드의 URL주소를 입력해주세요"
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
        
        urlTF.font = UIFont.boldSystemFont(ofSize: 15)
        urlTF.textColor = .black
        urlTF.backgroundColor = CustomColor.backgroundColor.color
        urlTF.layer.cornerRadius = 4
        urlTF.layer.borderColor = UIColor.gray.cgColor
        urlTF.layer.borderWidth = 0.5
        urlTF.returnKeyType = .done
        
        createButton.setTitle("STEP 1", for: .normal)
        createButton.tintColor = .black
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        createButton.clipsToBounds = true
        createButton.layer.cornerRadius = 8
        
        plusButton.tintColor = .lightGray
        plusButton.isUserInteractionEnabled = false
        
        
        customQRButton.backgroundColor = .lightGray
        customQRButton.tintColor = .black
        customQRButton.setTitle("QR 커스터마이징", for: .normal)
        customQRButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    
        secondUIView.isHidden = true
    }
    

    func showLottieAnimationWithLabel(text: String) {
        // Lottie 애니메이션 뷰 생성
        let animationView = LottieAnimationView(name: "LoadingQR")
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        makeQRContainerView.addSubview(animationView)
        self.animationView = animationView
        
        // UILabel 생성
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .darkGray
        makeQRContainerView.addSubview(label)
        self.loadingLabel = label
        
        // SnapKit 레이아웃 설정
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20) // 살짝 위로 올려서 레이블 공간 확보
            make.width.height.equalTo(150) // 원하는 크기로 설정
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(8) // 애니메이션 바로 아래에 배치
            make.centerX.equalToSuperview()
        }
        
        // 애니메이션 실행
        animationView.play()
    }
}

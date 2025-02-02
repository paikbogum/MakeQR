//
//  ResultView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/26/24.
//

import UIKit
import Lottie
import SnapKit

class ResultView: UIView {
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var randomMent: UILabel!
    @IBOutlet weak var downLoadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    
    var animationView: LottieAnimationView?
    var loadingLabel: UILabel?
    
    func setUI() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        resultContainerView.layer.cornerRadius = 8
        resultContainerView.clipsToBounds = true
        resultContainerView.backgroundColor = CustomColor.backgroundColor.color
        
        randomMent.textColor = .darkGray
        randomMent.font = UIFont.boldSystemFont(ofSize: 15)
        
        downLoadButton.layer.cornerRadius = 8
        downLoadButton.clipsToBounds = true
        downLoadButton.tintColor = .black
        downLoadButton.backgroundColor = CustomColor.backgroundColor.color
        downLoadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        shareButton.layer.cornerRadius = 8
        shareButton.clipsToBounds = true
        shareButton.tintColor = .black
        shareButton.backgroundColor = CustomColor.backgroundColor.color
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

        kakaoButton.layer.cornerRadius = 8
        kakaoButton.clipsToBounds = true
        kakaoButton.tintColor = .black
        kakaoButton.titleLabel?.textColor = .black
        kakaoButton.backgroundColor = .systemYellow
        kakaoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        randomMent.isHidden = true
        downLoadButton.isHidden = true
        shareButton.isHidden = true
        kakaoButton.isHidden = true
        resultImageView.isHidden = true
    }
    
    func showLottieAnimationWithLabel(text: String) {
        // Lottie 애니메이션 뷰 생성
        let animationView = LottieAnimationView(name: "LoadingQR")
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        resultContainerView.addSubview(animationView)
        self.animationView = animationView
        
        // UILabel 생성
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .darkGray
        resultContainerView.addSubview(label)
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
    
    
    func removeLottieAnimationAndLabel() {
        // 애니메이션 중지 및 제거
        animationView?.stop()
        animationView?.removeFromSuperview()
        animationView = nil
        
        // 레이블 제거
        loadingLabel?.removeFromSuperview()
        loadingLabel = nil
    }
}

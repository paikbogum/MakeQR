//
//  LoadingView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//
/*
import UIKit
import SnapKit
import dotLottie

final class LoadingView: UIView {
    static let shared = LoadingView()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    
    private let loadingView:  {
        let view = LottieAnimationView()
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.loadingView)
        
        self.contentView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
            $0.size.equalTo(300)
        }
        self.loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // .lottie 파일 로드 메서드
    private func loadDotLottieAnimation(named name: String) {
        do {
            if let dotLottie = try? DotLottie.load(name: name) {
                self.loadingView.animation = dotLottie.animation
            } else {
                print("Failed to load .lottie file")
            }
        } catch {
            print("Error loading .lottie file: \(error)")
        }
    }
    
    // show 메서드에서 부모 뷰와 애니메이션 파일 이름을 전달받도록 수정
    func show(in parentView: UIView, animationName: String) {
        guard !parentView.subviews.contains(where: { $0 is LoadingView }) else { return }
        
        // .lottie 파일 로드
        loadDotLottieAnimation(named: animationName)
        
        parentView.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
        
        print("애니메이션 실행됨")
        self.loadingView.play()
        UIView.animate(
            withDuration: 0.7,
            animations: { self.contentView.alpha = 1 }
        )
    }
    
    // hide 메서드는 기존 코드 그대로 유지
    func hide(completion: @escaping () -> () = {}) {
        self.loadingView.stop()
        self.removeFromSuperview()
        completion()
    }
}
*/

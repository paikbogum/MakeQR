//
//  MainViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var cameraButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var mainView: MainView!
    
    let cellName = "MainCollectionViewCell"
    let cellReuseIdentifier = "MainCollectionViewCell"
    
    let categoryList: [(String, String)] =  [("wifi", "Wi-Fi로 QR코드 만들기"), ("url", "URL로 QR코드 만들기"), ("text", "텍스트로 QR코드 만들기"), ("phone", "전화번호로 QR코드 만들기")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.mainViewUISetting()
        registerXib()
        
        mainView.mainCollectionView.layoutIfNeeded()
        
        if let layout = mainView.mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        mainView.mainCollectionView.register(nibName, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        mainView.mainCollectionView.delegate = self
        mainView.mainCollectionView.dataSource = self
    }
    
    /*
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        mainView.nextButton.isHidden = true
        // UILabel 애니메이션
        UIView.animate(withDuration: 0.5, animations: {
            self.mainView.mainLabelTopConstraint.constant = 60 // Top Constraint 변경
            self.cameraButtonTopConstraint.constant = 300
            self.view.layoutIfNeeded() // 레이아웃 갱신
        }, completion: { _ in
            // UILabel 애니메이션 완료 후 UICollectionView 애니메이션 실행
            self.mainView.mainCollectionView.isHidden = false // CollectionView 표시
            UIView.animate(withDuration: 0.5) {
                self.mainView.mainCollectionView.alpha = 1 // alpha 값을 서서히 증가
            }
        })
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else { return }
        
        //nextVC.categoryCase = destination
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }*/
    
    
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as?
                MainCollectionViewCell else {
            return UICollectionViewCell() }
        
        let target = categoryList[indexPath.row]
        cell.categoryImageView.image = UIImage(named: target.0)
        cell.categoryExplainText.text = target.1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destination = categoryList[indexPath.row].0
        
        if destination == "wifi" {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeWifiViewController") as? MakeWifiViewController else { return }
            
            //nextVC.categoryCase = destination
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        } else {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeQRViewController") as? MakeQRViewController else { return }
            
            nextVC.categoryCase = destination
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 20 // Safe Area 여백 (20 + 20)
        let width = collectionView.safeAreaLayoutGuide.layoutFrame.width - totalSpacing
        let height: CGFloat = 40 // 셀 높이 (원하는 대로 설정)
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

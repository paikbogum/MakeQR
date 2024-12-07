//
//  MainViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var mainView: MainView!
    
    let cellName = "MainCollectionViewCell"
    let cellReuseIdentifier = "MainCollectionViewCell"
    
    let categoryList: [(String, String)] =  [("wifi", "wifi를 QR코드로 생성"), ("url", "url을 QR코드로 생성"), ("text", "텍스트를 QR코드로 생성"), ("phone", "전화번호를 QR코드로 생성")]
    
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
        /*
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeQRViewController") as? MakeQRViewController else { return }
        let target = categoryList[indexPath.row].0
        
        nextVC.categoryCase = target
        self.navigationController?.pushViewController(nextVC, animated: true)*/
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 0 // Safe Area 여백 (20 + 20)
        let width = collectionView.safeAreaLayoutGuide.layoutFrame.width - totalSpacing
        let height: CGFloat = 60 // 셀 높이 (원하는 대로 설정)
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    

    
    
    
    
}

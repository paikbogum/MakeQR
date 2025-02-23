//
//  InfoViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 2/18/25.
//

import UIKit

class InfoViewController: UIViewController, CustomAlertDelegate {
    func show() {
        print("gd")
    }
    
    weak var delegate: CustomizingViewControllerDelegate?

    let cellName = "InfoTableViewCell"
    let cellReuseIdentifier = "InfoTableViewCell"
    
    var infoItems: [String] = ["QR 코드 색상?", "QR 코드 손상률?", "QR 코드 로고 선명도란?"]

    @IBOutlet var infoView: InfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoView.setUI()
        registerXib()
        
        self.navigationItem.title = "도움말"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: CustomColor.backgroundColor.color]

    }
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        infoView.infoTableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
        infoView.infoTableView.delegate = self
        infoView.infoTableView.dataSource = self
    }
 
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! InfoTableViewCell
        
        let target = infoItems[indexPath.row]
        
        cell.infoLabel.text = target
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = infoItems[indexPath.row]
        
        if target == "QR 코드 색상?" {
            show(titleLabel: "QR 코드 색상 안내", contentLabel: "QR코드는 일반적으로 전경색을 검은색, 배경색을 흰색이 기본적이지만, 다른 색상으로 설정할 수 있습니다.", tipLabel: "1. 전경색은 배경색과 충분한 대비를 이루어야 QR 코드 인식이 원활합니다.\n\n2. 배경색이 너무 어두우면 인식률이 낮아질 수 있습니다.\n\n3. 투명한 배경보다는 단색 배경이 인식률을 높이는 데 유리합니다.")
        } else if target == "QR 코드 손상률?" {
            show(titleLabel: "QR 코드 손상률 안내", contentLabel: "QR코드의 손상률은 QR코드의 중앙에 들어가는 로고의 크기를 결정합니다.", tipLabel: "1. 손상률이 높을수록(최대 30%) QR 코드의 복원력이 증가하지만, 로고 크기는 작아집니다.\n\n2. 손상률이 낮을수록 로고를 크게 넣을 수 있지만, 인식률이 감소할 수 있습니다.\n\n3. 일반적으로 10 ~ 30%의 손상률을 설정합니다.")
            
        } else {
            show(titleLabel: "QR 코드 로고 선명도 안내", contentLabel: "로고의 선명도는 QR 코드의 중앙에 들어갈 로고의 도트 뭉개짐 정도입니다.", tipLabel: "1. 로고 도트의 선명도가 높을수록, 로고의 원본 이미지와 비슷하게 출력됩니다.\n\n2. 로고의 복잡한 이미지는 도트화 과정에서 세부 사항이 손실될 수 있으므로 단순한 디자인이 유리합니다.")
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
}

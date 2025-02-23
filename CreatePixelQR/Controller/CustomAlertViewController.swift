//
//  CustomAlertViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 2/7/25.
//

import Foundation
import UIKit



protocol CustomAlertDelegate {
    func show()
}


class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!

    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate: CustomAlertDelegate?
    
    var titleText = ""
    var contentText = ""
    var tipText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingAll()
        setUI()
    }
    
    func settingAll() {
        titleLabel.text = titleText
        contentLabel.text = contentText
        tipLabel.text = tipText
    }
    
    func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alertView.layer.cornerRadius = 8
        alertView.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.textColor = .white
        
        tipView.layer.cornerRadius = 8
        tipView.backgroundColor = CustomColor.darkModeDarkGrayColor.color
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textColor = .white
        
        dismissButton.backgroundColor = .lightGray
        dismissButton.tintColor = .black
        dismissButton.layer.cornerRadius = 8
        dismissButton.setTitle("확인", for: .normal)
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension CustomAlertDelegate where Self: UIViewController {
    func show(
            titleLabel: String,
            contentLabel: String,
            tipLabel: String
        ) {
            
            let customAlertStoryboard = UIStoryboard(name: "CustomAlert", bundle: nil)
            let customAlertViewController = customAlertStoryboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            
            customAlertViewController.delegate = self
            
            customAlertViewController.modalPresentationStyle = .overFullScreen
            customAlertViewController.modalTransitionStyle = .crossDissolve
            customAlertViewController.titleText = titleLabel
            customAlertViewController.tipText = tipLabel
            customAlertViewController.contentText = contentLabel

            self.present(customAlertViewController, animated: true, completion: nil)
        }
}

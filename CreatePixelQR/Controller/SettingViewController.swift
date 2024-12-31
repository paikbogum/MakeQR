//
//  SettingViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/30/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet var settingView: SettingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView.setUI()
    }
}

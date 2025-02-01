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
    
    // 저장된 설정 불러오기
    private func loadSwitchStates() {
        settingView.makeHistorySwitch.isOn = UserDefaults.standard.bool(forKey: HistoryUserSetting.saveGeneratedQRHistory)
        settingView.detectHistorySwitch.isOn = UserDefaults.standard.bool(forKey: HistoryUserSetting.saveScannedQRHistory)
        
        settingView.vibrateSwitch.isOn = UserDefaults.standard.bool(forKey: UserSettings.enableVibrationOnScan)
    }
    
    
    @IBAction func vibrateSwitchToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserSettings.enableVibrationOnScan)
    }
    
    
    @IBAction func makeHistorySwitchToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: HistoryUserSetting.saveGeneratedQRHistory)
    }
    
    @IBAction func detectHistorySwitchToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: HistoryUserSetting.saveScannedQRHistory)
    }
    
    
    @IBAction func backCameraSwitchToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserSettings.useRearCamera)
    }
    
    @IBAction func customizingQRButtonTapped(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomizingViewController") as? CustomizingViewController else { return }
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}

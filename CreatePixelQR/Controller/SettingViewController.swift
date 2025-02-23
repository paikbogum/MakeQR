//
//  SettingViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/30/24.
//
import UIKit
import MessageUI


class SettingViewController: UIViewController {
    
    @IBOutlet var settingView: SettingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView.setUI()
        loadSwitchStates()
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
    
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else { return }
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    @IBAction func feedBackButtonTapped(_ sender: UIButton) {
        sendFeedbackEmail()
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let toastWidth: CGFloat = UIScreen.main.bounds.width * 0.8
        let toastHeight: CGFloat = 50
        toastLabel.frame = CGRect(
            x: (UIScreen.main.bounds.width - toastWidth) / 2,
            y: UIScreen.main.bounds.height - toastHeight - 150,
            width: toastWidth,
            height: toastHeight
        )
        
        UIApplication.shared.windows.first?.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.0, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func sendFeedbackEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("이메일을 보낼 수 없습니다.")
            showToast(message: "이메일을 보낼 수 없습니다.")
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["support@example.com"])
        mailVC.setSubject("앱 피드백")
        mailVC.setMessageBody("여기에 피드백 내용을 작성해주세요.", isHTML: false)
        
        present(mailVC, animated: true)
    }
    
    // 이메일 전송 완료 후 처리
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        showToast(message: "성공적으로 메일을 보냈습니다!")
    }
}

//
//  CustomizingViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 1/6/25.
//
import UIKit

protocol CustomizingViewControllerDelegate: AnyObject {
    func didSendDataBack(_ data: (qrPercent: CGFloat, dotPercent: CGFloat, foregroundCol: UIColor, backgroundCol: UIColor, logoCol: UIColor))
}

class CustomizingViewController: UIViewController {
    @IBOutlet var customizingView: CustomizingView!
    
    weak var delegate: CustomizingViewControllerDelegate?
    
    var selectedForegroundColor: UIColor = .black // 기본 색상
    var selectedBackgroundColor: UIColor = .white
    var selectedLogoColor: UIColor = .black
    
    var selectedQRPercent: CGFloat = 0.3
    var selectedDotPercent: CGFloat = 0.95

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingView.setColorSetUI()
        customizingView.setLogoSetUI()
        customizingView.setQrSetUI()
        updateColorSetting()
    }
    
    private func updateColorSetting() {
        customizingView.color1Button.backgroundColor = selectedForegroundColor
        customizingView.color2Button.backgroundColor = selectedBackgroundColor
        customizingView.color3Button.backgroundColor = selectedLogoColor
    }
    
    @IBAction func pickForegroundColor(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = selectedForegroundColor
        colorPicker.delegate = self
        colorPicker.title = "전경색 선택"
        colorPicker.accessibilityLabel = "QR 코드 패턴 색상 선택"
        present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func pickBackgroundColor(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = selectedBackgroundColor
        colorPicker.delegate = self
        colorPicker.title = "배경색 선택"
        colorPicker.accessibilityLabel = "QR 코드 배경 색상 선택"
        present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func pickLogoColor(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = selectedLogoColor
        colorPicker.delegate = self
        colorPicker.title = "로고색 선택"
        colorPicker.accessibilityLabel = "QR 코드 로고 색상 선택"
        present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        delegate?.didSendDataBack((selectedQRPercent, selectedDotPercent, selectedForegroundColor, selectedBackgroundColor, selectedLogoColor))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoDotSliderValueChanged(_ sender: UISlider) {
        customizingView.logoDotValueLabel.text = String(Int(sender.value)) + "%"
        selectedDotPercent = CGFloat(sender.value / 100)
    }
    
    @IBAction func qrSetSliderValueChanged(_ sender: UISlider) {
        customizingView.qrSetValueLabel.text = String(Int(sender.value * 100)) + "%"
        selectedQRPercent = CGFloat(sender.value)
    }
}

extension CustomizingViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        // 사용자가 색상을 선택하고 완료했을 때
        if viewController.title == "전경색 선택" {
            selectedForegroundColor = viewController.selectedColor
        } else if viewController.title == "배경색 선택" {
            selectedBackgroundColor = viewController.selectedColor
        } else if viewController.title == "로고색 선택" {
            selectedLogoColor = viewController.selectedColor
        }
        //updateQRCodePreview()
        updateColorSetting()
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // 사용자가 실시간으로 색상을 변경할 때 (선택적으로 반영 가능)
    }
}

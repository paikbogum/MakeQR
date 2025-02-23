//
//  MakeWifiViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/5/24.
//

import Foundation
import UIKit
import Mantis

class MakeWifiViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate, CustomizingViewControllerDelegate  {
    
    func didSendDataBack(_ data: (qrPercent: CGFloat, dotVal: Int, foregroundCol: UIColor, backgroundCol: UIColor, logoCol: UIColor, qrSizeSet: String)) {
        receiveQRPercent = data.qrPercent
        receiveDotVal = data.dotVal
        receiveForegroundColor = data.foregroundCol
        receiveBackgroundColor = data.backgroundCol
        receiveDotColor = data.logoCol
        receiveSize = data.qrSizeSet
        
    }
    
    private var qrProcessor = QRProcessor()
    
    @IBOutlet var makeWifiView: MakeWifiView!
    
    @IBOutlet weak var textContainerBottomConstraint: NSLayoutConstraint!
    
    var receiveWifiData: String?
    
    let securityTypes = ["WPA/WPA2", "WEP", "None"]
    let hiddenOptions = ["공개", "숨김"]
    
    var selectedImageBool: Bool = false
    var urlTFBool: Bool = false
    var buttonBool: Bool = false
    var wifiHiddenBool: Bool = false
    
    var selectedSecurityType: String?
    var selectedHiddenOption: String?
    
    var receiveQRPercent: CGFloat = 0.3
    var receiveDotVal: Int = 20
    
    var receiveForegroundColor: UIColor = .black
    var receiveBackgroundColor: UIColor = .white
    var receiveDotColor: UIColor = .black
    var receiveSize: String = "900"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeWifiView.MakeQRViewUISetting()
        setupPickerViews()
        setTextfield()
        changeStateOfTF()
        if let data = receiveWifiData {
            changeStateOfCategory(data: data)
        }
        changeCreateButtonState()
    }
    
    private func changeCreateButtonState() {
        if makeWifiView.createButton.isEnabled {
            makeWifiView.createButton.backgroundColor = CustomColor.caldendarFontColor.color
        } else {
            makeWifiView.createButton.backgroundColor = .systemGray
        }
        
        // 2조건을 만족시킨다면 버튼의 용도가 달라짐
        if urlTFBool && selectedImageBool {
            buttonBool = true
        } else {
            buttonBool = false
        }
    }
    
    private func changeStateOfCategory(data: String) {
        if let wifiInfo = parseWiFiData(data) {
            makeWifiView.wifiNameTF.text = wifiInfo.ssid
            makeWifiView.wifiPasswordTF.text = wifiInfo.password
            makeWifiView.wifiSecurityTypeTF.text = wifiInfo.security
            makeWifiView.wifiHiddenTF.text = wifiInfo.hidden ? hiddenOptions[1] : hiddenOptions[0]
            
            urlTFBool = true
            changeStateOfTF()
        }
    }
     
    private func changeStateOfTF() {
        if urlTFBool {
            makeWifiView.secondUIView.layer.borderColor = CustomColor.caldendarFontColor.color.cgColor
            makeWifiView.secondStepButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            makeWifiView.secondStepButton.tintColor = CustomColor.caldendarFontColor.color
            makeWifiView.secondStepLabel.textColor = CustomColor.caldendarFontColor.color
            makeWifiView.createButton.setTitle("Next", for: .normal)
            makeWifiView.createButton.isEnabled = true
            
        } else {
            makeWifiView.secondUIView.layer.borderColor = CustomColor.darkModeDarkGrayColor.color.cgColor
            makeWifiView.secondStepButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            makeWifiView.secondStepButton.tintColor = .lightGray
            makeWifiView.secondStepLabel.textColor = .lightGray
            makeWifiView.createButton.setTitle("STEP 1", for: .normal)
            makeWifiView.createButton.isEnabled = false
            
            makeWifiView.secondUIView.isHidden = false
            textContainerBottomConstraint.constant = 20
            makeWifiView.firstUIView.isHidden = true
            
        }
        changeCreateButtonState()
        // 변경 사항 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func changeStateOfImage() {
        if selectedImageBool {
            makeWifiView.selectImageButton.alpha = 0
            makeWifiView.firstUIView.layer.borderColor = CustomColor.caldendarFontColor.color.cgColor
            makeWifiView.firstStepButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            makeWifiView.firstStepButton.tintColor = CustomColor.caldendarFontColor.color
            makeWifiView.firstStepLabel.textColor = CustomColor.caldendarFontColor.color

            makeWifiView.createButton.setTitle("Make QR!", for: .normal)
            makeWifiView.createButton.isEnabled = true
            
        } else {
            makeWifiView.selectImageButton.alpha = 1
            makeWifiView.firstUIView.layer.borderColor = CustomColor.darkModeDarkGrayColor.color.cgColor
            makeWifiView.firstStepButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            makeWifiView.firstStepButton.tintColor = .lightGray
            makeWifiView.firstStepLabel.textColor = .lightGray

            makeWifiView.createButton.setTitle("STEP 2", for: .normal)
            makeWifiView.createButton.isEnabled = false
        }
        
        changeCreateButtonState()
    }
    
    @IBAction func customQRButtonTapped(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "CustomizingViewController") as? CustomizingViewController {
     
            nextVC.delegate = self
            
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        if buttonBool {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                nextVC.receiveCroppedImage = makeWifiView.selectedImageView.image

                nextVC.qrType = .wifi(ssid: makeWifiView.wifiNameTF.text!, password: makeWifiView.wifiPasswordTF.text!, security: makeWifiView.wifiSecurityTypeTF.text!, hidden: wifiHiddenBool)
                
                nextVC.receiveQRPercent = self.receiveQRPercent
                nextVC.receiveDotVal = self.receiveDotVal
                nextVC.receiveForegroundColor = self.receiveForegroundColor
                nextVC.receiveBackgroundColor = self.receiveBackgroundColor
                nextVC.receiveDotColor = self.receiveDotColor
                nextVC.receiveSize = self.receiveSize
                
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            let qrCode = qrProcessor.generateQRCode(from: .wifi(ssid: makeWifiView.wifiNameTF.text!, password: makeWifiView.wifiPasswordTF.text!, security: makeWifiView.wifiSecurityTypeTF.text!, hidden: wifiHiddenBool), clearRatio: 0.0, dotImage: nil, foregroundColor: .black, backgroundColor: .white)
            
            makeWifiView.firstUIView.isHidden = false
            textContainerBottomConstraint.constant = 330
            
            makeWifiView.wifiNameTF.isUserInteractionEnabled = false
            makeWifiView.wifiPasswordTF.isUserInteractionEnabled = false
            makeWifiView.wifiSecurityTypeTF.isUserInteractionEnabled = false
            makeWifiView.wifiHiddenTF.isUserInteractionEnabled = false

            //makeWifiView.urlTF.textColor = .green
            makeWifiView.qrPreviewImageView.image = qrCode
            
            urlTFBool = true
            changeStateOfImage()

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    
    
    private func setTextfield() {
        makeWifiView.wifiNameTF.delegate = self
        makeWifiView.wifiNameTF.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        makeWifiView.wifiPasswordTF.delegate = self
        makeWifiView.wifiPasswordTF.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        makeWifiView.wifiSecurityTypeTF.delegate = self
        makeWifiView.wifiSecurityTypeTF.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        makeWifiView.wifiHiddenTF.delegate = self
        makeWifiView.wifiHiddenTF.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
    }
    
    // Return 키를 눌렀을 때 호출되는 메서드
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // Return 키가 눌렸을 때
            textView.resignFirstResponder() // 키보드 내리기
            return false // 줄바꿈을 막기 위해 false 반환
        }
        return true
    }
    
    // 빈 화면을 터치 시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        // 첫 글자가 공백인 경우 처리
        if let text = textField.text, text.count == 1, text.first == " " {
            textField.text = ""
            return
        }

        // 필수 입력 필드 확인
        let requiredFields = [
            makeWifiView.wifiNameTF.text,
            makeWifiView.wifiPasswordTF.text,
            makeWifiView.wifiSecurityTypeTF.text,
            makeWifiView.wifiHiddenTF.text
        ]

        // 필드 중 하나라도 비어 있다면 처리
        if requiredFields.contains(where: { $0?.isEmpty ?? true }) {
            urlTFBool = false
            changeStateOfTF()
            return
        }
        

        // 모든 조건을 만족한 경우
        urlTFBool = true
        changeStateOfTF()
    }
    
    func parseWiFiData(_ data: String) -> (ssid: String, password: String, security: String, hidden: Bool)? {
        guard data.hasPrefix("WIFI:") else { return nil }

        let components = data
            .replacingOccurrences(of: "WIFI:", with: "")
            .components(separatedBy: ";")

        var ssid = ""
        var password = ""
        var security = "WPA" // 기본값
        var hidden = false

        for component in components {
            if component.hasPrefix("S:") {
                ssid = component.replacingOccurrences(of: "S:", with: "")
            } else if component.hasPrefix("P:") {
                password = component.replacingOccurrences(of: "P:", with: "")
            } else if component.hasPrefix("T:") {
                security = component.replacingOccurrences(of: "T:", with: "")
            } else if component.hasPrefix("H:") {
                hidden = component.replacingOccurrences(of: "H:", with: "") == "true"
            }
        }

        return (ssid, password, security, hidden)
    }

}

// MARK: - UIPickerViewDelegate & DataSource
extension MakeWifiViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupPickerViews() {
          // 보안 유형 Picker
          let securityPicker = UIPickerView()
          securityPicker.delegate = self
          securityPicker.dataSource = self
          securityPicker.tag = 0
        makeWifiView.wifiSecurityTypeTF.inputView = securityPicker
          
          // 숨겨진 네트워크 Picker
          let hiddenPicker = UIPickerView()
          hiddenPicker.delegate = self
          hiddenPicker.dataSource = self
          hiddenPicker.tag = 1
        makeWifiView.wifiHiddenTF.inputView = hiddenPicker
          
          // Toolbar 추가
          let toolbar = UIToolbar()
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
          toolbar.setItems([doneButton], animated: true)
          toolbar.isUserInteractionEnabled = true
          
        makeWifiView.wifiSecurityTypeTF.inputAccessoryView = toolbar
        makeWifiView.wifiHiddenTF.inputAccessoryView = toolbar
      }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }

      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return pickerView.tag == 0 ? securityTypes.count : hiddenOptions.count
      }

      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return pickerView.tag == 0 ? securityTypes[row] : hiddenOptions[row]
      }

      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          if pickerView.tag == 0 {
              selectedSecurityType = securityTypes[row]
              makeWifiView.wifiSecurityTypeTF.text = selectedSecurityType
          } else {
              selectedHiddenOption = hiddenOptions[row]
              makeWifiView.wifiHiddenTF.text = selectedHiddenOption
              
              // visible과 hidden에 따라 wifiHiddenBool 설정
              if selectedHiddenOption == "공개" {
                  wifiHiddenBool = false

              } else if selectedHiddenOption == "숨김" {
                  wifiHiddenBool = true
              }
          }
          
          // textFieldEditingChanged를 명시적으로 호출
          textFieldEditingChanged(pickerView.tag == 0 ? makeWifiView.wifiSecurityTypeTF : makeWifiView.wifiHiddenTF)
          
      }
}

extension MakeWifiViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        cropViewController.dismiss(animated: true, completion: nil)
        makeWifiView.selectedImageView.image = cropped
        self.selectedImageBool = true
        
        changeStateOfImage()
        changeCreateButtonState()
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension MakeWifiViewController: UIImagePickerControllerDelegate {
    // 이미지 피커에서 이미지를 선택하지 않고 취소했을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 이미지 피커 컨트롤러 창 닫기
        print("이미지 선택하지않고 취소한 경우")
        
        self.dismiss(animated: false) { () in
            // 알림 창 호출
            let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
    }
    // 이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("이미지 선택")
        picker.dismiss(animated: false) {
            // 편집된 이미지가 없으면 원본 이미지를 사용
            let img = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
            
            // 이미지가 nil인지 확인 후 처리
            guard let selectedImage = img else {
                print("이미지가 선택되지 않았습니다.")
                return
            }
            
            // Mantis 크롭 컨트롤러 설정
            let cropViewController = Mantis.cropViewController(image: selectedImage)
            cropViewController.delegate = self
            
            // 정사각형으로 고정된 비율 설정
            cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1.0)
            cropViewController.config.cropViewConfig.cropShapeType = .rect
            cropViewController.config.ratioOptions = [.custom] // 사용자 정의 비율만 허용
            
            self.present(cropViewController, animated: true)
        }
    }
}


//
//  MakeQRViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit
import Lottie
import SnapKit
import Mantis

class MakeQRViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, CustomizingViewControllerDelegate {
    
    func didSendDataBack(_ data: (qrPercent: CGFloat, dotVal: Int, foregroundCol: UIColor, backgroundCol: UIColor, logoCol: UIColor, qrSizeSet: String, eyeShape: QREyeShape, bodyShape: QRBodyShape)) {
        
        receiveQRPercent = data.qrPercent
        receiveDotVal = data.dotVal
        receiveForegroundColor = data.foregroundCol
        receiveBackgroundColor = data.backgroundCol
        receiveDotColor = data.logoCol
        receiveSize = data.qrSizeSet
        
        receiveEyeShape = data.eyeShape
        receiveBodyShape = data.bodyShape
        
        print(data)
    }
    
    private var qrProcessor = QRProcessor()
    @IBOutlet var makeQRView: MakeQRView!
    
    @IBOutlet weak var textContainerBottomConstraint: NSLayoutConstraint!
    
    var selectedImageBool: Bool = false
    var urlTFBool: Bool = false
    var buttonBool: Bool = false
    
    var categoryCase = ""
    var receiveData: String?
    
    var receiveQRPercent: CGFloat = 0.3
    var receiveDotVal: Int = 20
    
    var receiveForegroundColor: UIColor = .black
    var receiveBackgroundColor: UIColor = .white
    var receiveDotColor: UIColor = .black
    var receiveSize: String = "900"
    
    var receiveEyeShape: QREyeShape = .eye_square
    var receiveBodyShape: QRBodyShape = .data_square
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeQRView.MakeQRViewUISetting()
        loadQRSettings()
        setTextfield()
        changeStateOfTF()
        changeStateOfCategory()
        changeCreateButtonState()
        
        print(categoryCase)
    }
    
    private func changeStateOfCategory() {
        switch categoryCase {
        case "URL":
            if let data = receiveData {
                makeQRView.urlTF.text = data
                urlTFBool = true
                changeStateOfTF()
            }
            
            makeQRView.secondStepLabel.text = "생성할 QR코드의 URL주소를 입력해주세요"
            makeQRView.urlTF.attributedPlaceholder = NSAttributedString(
                string: "ex) http://", // placeholder 텍스트
                attributes: [
                    .foregroundColor: UIColor.lightGray  // 원하는 색상 지정
                ]
            )
            makeQRView.urlTF.keyboardType = .URL

        case "Text":
            if let data = receiveData {
                makeQRView.urlTF.text = data
                urlTFBool = true
                changeStateOfTF()
                
            }
            makeQRView.secondStepLabel.text = "생성할 QR코드의 텍스트를 입력해주세요"
            makeQRView.urlTF.attributedPlaceholder = NSAttributedString(
                string: "ex) 안녕하세요!", // placeholder 텍스트
                attributes: [
                    .foregroundColor: UIColor.lightGray  // 원하는 색상 지정
                ]
            )
        case "Phone":
            if let data = receiveData {
                makeQRView.urlTF.text = data
                urlTFBool = true
                changeStateOfTF()
                
            }
            makeQRView.secondStepLabel.text = "생성할 QR코드의 전화번호를 입력해주세요"
            makeQRView.urlTF.attributedPlaceholder = NSAttributedString(
                string: "ex) 010xxxxxxxx", // placeholder 텍스트
                attributes: [
                    .foregroundColor: UIColor.lightGray // 원하는 색상 지정
                ]
            )
        case "Email":
            if let data = receiveData {
                makeQRView.urlTF.text = data
                urlTFBool = true
                changeStateOfTF()
            }
            makeQRView.secondStepLabel.text = "생성할 QR코드의 이메일을 입력해주세요"
            makeQRView.urlTF.attributedPlaceholder =  NSAttributedString(
                string: "ex) makeqr@google.com", // placeholder 텍스트
                attributes: [
                    .foregroundColor: UIColor.lightGray // 원하는 색상 지정
                ]
            )
            makeQRView.urlTF.keyboardType = .emailAddress
        default:
            break
        }
    }
    
    private func checkUrlMethod() {
        // http 또는 https로 시작하지 않는 경우 처리
        if !(makeQRView.urlTF.text!.hasPrefix("http://") || makeQRView.urlTF.text!.hasPrefix("https://")) {
            
            showAlert(for: makeQRView.urlTF)
            urlTFBool = false
            
            changeStateOfTF()
            changeCreateButtonState()
        } else {
            urlTFBool = true
            if buttonBool {
                if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                    
                    nextVC.receiveCroppedImage = makeQRView.seletedImageView.image
                    
                    nextVC.qrType = .url(makeQRView.urlTF.text!)
                    
                    nextVC.receiveQRPercent = self.receiveQRPercent
                    nextVC.receiveDotVal = self.receiveDotVal
                    nextVC.receiveForegroundColor = self.receiveForegroundColor
                    nextVC.receiveBackgroundColor = self.receiveBackgroundColor
                    nextVC.receiveDotColor = self.receiveDotColor
                    nextVC.receiveSize = self.receiveSize
                    nextVC.receiveEyeShape = self.receiveEyeShape
                    nextVC.receiveBodyShape = self.receiveBodyShape
                    
                    navigationController?.pushViewController(nextVC, animated: true)
                }
            } else {
                let qrCode = qrProcessor.generateQRCode(from: .url(makeQRView.urlTF.text!), clearRatio: 0.0, dotImage: nil, foregroundColor: .black, backgroundColor: .white)
                
                makeQRView.firstUIView.isHidden = false
                textContainerBottomConstraint.constant = 330
                makeQRView.urlTF.isUserInteractionEnabled = false
                makeQRView.urlTF.textColor = CustomColor.caldendarFontColor.color
                makeQRView.qrPreviewImageView.image = qrCode
                
                urlTFBool = true
                changeStateOfImage()
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func checkTextMethod() {
        if buttonBool {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                
                nextVC.receiveCroppedImage = makeQRView.seletedImageView.image
                
                nextVC.qrType = .text(makeQRView.urlTF.text!)
                //nextVC.receiveUrl = makeQRView.urlTF.text!
                
                nextVC.receiveQRPercent = self.receiveQRPercent
                nextVC.receiveDotVal = self.receiveDotVal
                nextVC.receiveForegroundColor = self.receiveForegroundColor
                nextVC.receiveBackgroundColor = self.receiveBackgroundColor
                nextVC.receiveDotColor = self.receiveDotColor
                nextVC.receiveSize = self.receiveSize
                nextVC.receiveEyeShape = self.receiveEyeShape
                nextVC.receiveBodyShape = self.receiveBodyShape
                
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            let qrCode = qrProcessor.generateQRCode(from: .text(makeQRView.urlTF.text!), clearRatio: 0.0, dotImage: nil, foregroundColor: .black, backgroundColor: .white)
            
            makeQRView.firstUIView.isHidden = false
            textContainerBottomConstraint.constant = 330
            makeQRView.urlTF.isUserInteractionEnabled = false
            makeQRView.urlTF.textColor = CustomColor.caldendarFontColor.color
            makeQRView.qrPreviewImageView.image = qrCode
            
            urlTFBool = true
            changeStateOfImage()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func checkPhoneMethod() {
        if buttonBool {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                
                nextVC.receiveCroppedImage = makeQRView.seletedImageView.image
                
                nextVC.qrType = .phone(makeQRView.urlTF.text!)
                //nextVC.receiveUrl = makeQRView.urlTF.text!
                nextVC.receiveQRPercent = self.receiveQRPercent
                nextVC.receiveDotVal = self.receiveDotVal
                nextVC.receiveForegroundColor = self.receiveForegroundColor
                nextVC.receiveBackgroundColor = self.receiveBackgroundColor
                nextVC.receiveDotColor = self.receiveDotColor
                nextVC.receiveSize = self.receiveSize
                nextVC.receiveEyeShape = self.receiveEyeShape
                nextVC.receiveBodyShape = self.receiveBodyShape
                
                
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            let qrCode = qrProcessor.generateQRCode(from: .phone(makeQRView.urlTF.text!), clearRatio: 0.0, dotImage: nil, foregroundColor: .black, backgroundColor: .white)
            
            makeQRView.firstUIView.isHidden = false
            textContainerBottomConstraint.constant = 330
            makeQRView.urlTF.isUserInteractionEnabled = false
            makeQRView.urlTF.textColor = CustomColor.caldendarFontColor.color
            makeQRView.qrPreviewImageView.image = qrCode
            
            urlTFBool = true
            changeStateOfImage()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    private func checkEmailMethod() {
        if buttonBool {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                
                nextVC.receiveCroppedImage = makeQRView.seletedImageView.image
                
                nextVC.qrType = .email(makeQRView.urlTF.text!)
                //nextVC.receiveUrl = makeQRView.urlTF.text!
                nextVC.receiveQRPercent = self.receiveQRPercent
                nextVC.receiveDotVal = self.receiveDotVal
                nextVC.receiveForegroundColor = self.receiveForegroundColor
                nextVC.receiveBackgroundColor = self.receiveBackgroundColor
                nextVC.receiveDotColor = self.receiveDotColor
                nextVC.receiveSize = self.receiveSize
                nextVC.receiveEyeShape = self.receiveEyeShape
                nextVC.receiveBodyShape = self.receiveBodyShape
                
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            let qrCode = qrProcessor.generateQRCode(from: .email(makeQRView.urlTF.text!), clearRatio: 0.0, dotImage: nil, foregroundColor: .black, backgroundColor: .white)
            
            makeQRView.firstUIView.isHidden = false
            textContainerBottomConstraint.constant = 330
            makeQRView.urlTF.isUserInteractionEnabled = false
            makeQRView.urlTF.textColor = CustomColor.caldendarFontColor.color
            makeQRView.qrPreviewImageView.image = qrCode
            
            urlTFBool = true
            changeStateOfImage()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func customQRButtonTapped(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "CustomizingViewController") as? CustomizingViewController {
     
            nextVC.delegate = self
            
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        switch categoryCase {
        case "URL":
            checkUrlMethod()
        case "Text":
            checkTextMethod()
        case "Phone":
            checkPhoneMethod()
        case "Email":
            checkEmailMethod()
        default:
            break
        }
    }
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    private func changeCreateButtonState() {
        if makeQRView.createButton.isEnabled {
            makeQRView.createButton.backgroundColor = CustomColor.caldendarFontColor.color
        } else {
            makeQRView.createButton.backgroundColor = .systemGray
        }
        
        // 2조건을 만족시킨다면 버튼의 용도가 달라짐
        if urlTFBool && selectedImageBool {
            buttonBool = true
        } else {
            buttonBool = false
        }
    }
    
    private func changeStateOfImage() {
        if selectedImageBool {
            makeQRView.selectImageButton.alpha = 0
            makeQRView.firstUIView.layer.borderColor = CustomColor.caldendarFontColor.color.cgColor
            makeQRView.firstStepButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            makeQRView.firstStepButton.tintColor = CustomColor.caldendarFontColor.color
            makeQRView.firstStepLabel.textColor = CustomColor.caldendarFontColor.color
            
            makeQRView.createButton.setTitle("Make QR!", for: .normal)
            makeQRView.createButton.isEnabled = true
            
        } else {
            makeQRView.selectImageButton.alpha = 1
            makeQRView.firstUIView.layer.borderColor = CustomColor.darkModeDarkGrayColor.color.cgColor
            makeQRView.firstStepButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            makeQRView.firstStepButton.tintColor = .lightGray
            makeQRView.firstStepLabel.textColor = .lightGray
            
            makeQRView.createButton.setTitle("STEP 2", for: .normal)
            makeQRView.createButton.isEnabled = false
        }
        
        changeCreateButtonState()
    }

    private func changeStateOfTF() {
        if urlTFBool {
            makeQRView.secondUIView.layer.borderColor = CustomColor.caldendarFontColor.color.cgColor
            makeQRView.secondStepButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            makeQRView.secondStepButton.tintColor = CustomColor.caldendarFontColor.color
            makeQRView.secondStepLabel.textColor = CustomColor.caldendarFontColor.color
            makeQRView.createButton.setTitle("Next", for: .normal)
            makeQRView.createButton.isEnabled = true
            
        } else {
            makeQRView.secondUIView.layer.borderColor = CustomColor.darkModeDarkGrayColor.color.cgColor
            makeQRView.secondStepButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            makeQRView.secondStepButton.tintColor = .lightGray
            makeQRView.secondStepLabel.textColor = .lightGray
            makeQRView.createButton.setTitle("STEP 1", for: .normal)
            makeQRView.createButton.isEnabled = false
            
            makeQRView.secondUIView.isHidden = false
            textContainerBottomConstraint.constant = 20
            makeQRView.firstUIView.isHidden = true
            
        }
        changeCreateButtonState()
        // 변경 사항 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func loadQRSettings() {
        let defaults = UserDefaults.standard
        
        // QR 전경색 (패턴 색)
        if let foregroundHex = defaults.string(forKey: QRDefaults.qrForegroundColor) {
            receiveForegroundColor = UIColor(hexString: foregroundHex)
        } else {
            receiveForegroundColor = .black // 기본값
        }
        
        // QR 배경색
        if let backgroundHex = defaults.string(forKey: QRDefaults.qrBackgroundColor) {
            receiveBackgroundColor = UIColor(hexString: backgroundHex)
        } else {
            receiveBackgroundColor = .white // 기본값
        }
        
        // QR 로고 색
        if let logoHex = defaults.string(forKey: QRDefaults.qrLogoColor) {
            receiveDotColor = UIColor(hexString: logoHex)
        } else {
            receiveDotColor = .black // 기본값
        }
        
        // QR 손상율 (기본 30%)
        if defaults.object(forKey: QRDefaults.qrDamageCorrection) != nil {
            receiveQRPercent = CGFloat(defaults.float(forKey: QRDefaults.qrDamageCorrection))
        } else {
            receiveQRPercent = 0.3
        }
        
        // QR 로고 도트 선명도 (기본 20)
        if defaults.object(forKey: QRDefaults.qrLogoDotSharpness) != nil {
            receiveDotVal = defaults.integer(forKey: QRDefaults.qrLogoDotSharpness)
        } else {
            receiveDotVal = 20
        }
        
        //QR 사이즈
        if let qrsizeString = defaults.string(forKey: QRDefaults.qrSize) {
            receiveSize = qrsizeString
        } else {
            print("userDefaults 저장 안됨")
            receiveSize = "900"
        }
    }
    
    //MARK: - Textfield
    
    private func setTextfield() {
        makeQRView.urlTF.delegate = self
        makeQRView.urlTF.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        makeQRView.urlTF.resignFirstResponder()
        return true
    }
    
    // 빈 화면을 터치 시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        // 첫 글자가 공백인 경우 처리
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        // 텍스트가 없는 경우 처리
        guard let text = makeQRView.urlTF.text, !text.isEmpty else {
            urlTFBool = false
            changeStateOfTF()
            return
        }
        
        
        // 모든 조건을 만족한 경우
        urlTFBool = true
        changeStateOfTF()
        
    }
    
    // Alert 표시 함수
    func showAlert(for textField: UITextField) {
        let alert = UIAlertController(title: "Invalid URL", message: "URL은 http:// 또는 https://로 시작해야 합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            // 알림 닫고 텍스트필드 초기화
            textField.text = ""
        }))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - 이미지 편집
extension MakeQRViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        cropViewController.dismiss(animated: true, completion: nil)
        makeQRView.seletedImageView.image = cropped
        self.selectedImageBool = true
        
        changeStateOfImage()
        changeCreateButtonState()
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension MakeQRViewController: UIImagePickerControllerDelegate {
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

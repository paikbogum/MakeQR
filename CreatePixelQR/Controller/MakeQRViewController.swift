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

class MakeQRViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    private var qrProcessor = QRProcessor()
    @IBOutlet var makeQRView: MakeQRView!
    
    @IBOutlet weak var textContainerBottomConstraint: NSLayoutConstraint!
    
    var selectedImageBool: Bool = false
    var urlTFBool: Bool = false
    var buttonBool: Bool = false
    
    var categoryCase = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeQRView.MakeQRViewUISetting()
        setTextfield()
        changeStateOfTF()
        changeStateOfCategory()
        changeCreateButtonState()
    }
    
    private func changeStateOfCategory() {
        switch categoryCase {
        case "url":
            makeQRView.secondStepLabel.text = "생성할 QR코드의 URL주소를 입력해주세요"
        case "wifi":
            makeQRView.secondStepLabel.text = "생성할 QR코드의 wifi이름을 입력해주세요"
        case "text":
            makeQRView.secondStepLabel.text = "생성할 QR코드의 텍스트를 적어주세요"
        default:
            break
        }
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        if buttonBool {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                nextVC.receiveCroppedImage = makeQRView.seletedImageView.image
                nextVC.receiveUrl = makeQRView.urlTF.text!
                
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            let qrCode = qrProcessor.generateQRCode(from: makeQRView.urlTF.text!, clearRatio: 0.0)
            
            makeQRView.firstUIView.isHidden = false
            textContainerBottomConstraint.constant = 330
            makeQRView.urlTF.isUserInteractionEnabled = false
            makeQRView.urlTF.textColor = .green
            makeQRView.qrPreviewImageView.image = qrCode
            
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
    
    private func changeCreateButtonState() {
        if makeQRView.createButton.isEnabled {
            makeQRView.createButton.backgroundColor = .systemGreen
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
            makeQRView.firstUIView.layer.borderColor = UIColor.green.cgColor
            makeQRView.firstStepButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            makeQRView.firstStepButton.tintColor = .green
            makeQRView.firstStepLabel.textColor = .green

            makeQRView.createButton.setTitle("Make QR!", for: .normal)
            makeQRView.createButton.isEnabled = true
            
        } else {
            makeQRView.selectImageButton.alpha = 1
            makeQRView.firstUIView.layer.borderColor = UIColor.white.cgColor
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
            makeQRView.secondUIView.layer.borderColor = UIColor.green.cgColor
            makeQRView.secondStepButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            makeQRView.secondStepButton.tintColor = .green
            makeQRView.secondStepLabel.textColor = .green
            makeQRView.createButton.setTitle("Next", for: .normal)
            makeQRView.createButton.isEnabled = true
            
        } else {
            makeQRView.secondUIView.layer.borderColor = UIColor.white.cgColor
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
    
    //MARK: - Textfield
    
    private func setTextfield() {
        makeQRView.urlTF.delegate = self
        makeQRView.urlTF.placeholder = "ex) http://"
        makeQRView.urlTF.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
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
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard let text = makeQRView.urlTF.text,
              !text.isEmpty else {
            
            urlTFBool = false
            changeStateOfTF()
            return
        }
        
        urlTFBool = true
        
        changeStateOfTF()
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

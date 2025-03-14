//
//  CustomizingViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 1/6/25.
//
import UIKit

protocol CustomizingViewControllerDelegate: AnyObject {
    func didSendDataBack(_ data: (qrPercent: CGFloat, dotVal: Int, foregroundCol: UIColor, backgroundCol: UIColor, logoCol: UIColor, qrSizeSet: String, eyeShape: QREyeShape, bodyShape: QRBodyShape))
}

class CustomizingViewController: UIViewController, CustomAlertDelegate {
    func show() {
        print("gd")
    }
    
    @IBOutlet var customizingView: CustomizingView!
    
    weak var delegate: CustomizingViewControllerDelegate?
    
    var selectedForegroundColor: UIColor = .black // 기본 색상
    var selectedBackgroundColor: UIColor = .white
    var selectedLogoColor: UIColor = .black
    
    var selectedQRPercent: CGFloat = 0.3
    var selectedDotVal: Int = 20
    
    var selectedSizeOption: String = ""
    var sizeOptions = ["300", "600", "900", "1200", "1500"]
    
    var selectedEyeShape: QREyeShape = .eye_square
    var selectedBodyShape: QRBodyShape = .data_square
    
    let cellName = "EyeShapeCollectionViewCell"
    let cellReuseIdentifier = "EyeShapeCollectionViewCell"
    
    let cellName2 = "BodyShapeCollectionViewCell"
    let cellReuseIdentifier2 = "BodyShapeCollectionViewCell"
    
    let eyeShapes = QREyeShape.allCases
    let bodyShapes = QRBodyShape.allCases
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingView.setColorSetUI()
        customizingView.setLogoSetUI()
        customizingView.setQrSetUI()
        customizingView.setQRsizeUI()
        customizingView.setEyeShapeUI()
        customizingView.setBodyShapeUI()
        registerXib()
        
        loadQRSettings()
        updateColorSetting()
        setupPickerViews()
        
        print(eyeShapes.count, bodyShapes.count)
        
        self.navigationItem.title = "QR 사용자 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: CustomColor.backgroundColor.color]
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        customizingView.eyeShapeCollectionView.register(nibName, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        customizingView.eyeShapeCollectionView.delegate = self
        customizingView.eyeShapeCollectionView.dataSource = self
        
        
        let nibName2 = UINib(nibName: cellName2, bundle: nil)
        customizingView.bodyShapeCollectionView.register(nibName2, forCellWithReuseIdentifier: cellReuseIdentifier2)
        
        customizingView.bodyShapeCollectionView.delegate = self
        customizingView.bodyShapeCollectionView.dataSource = self
    }
    
    func loadQRSettings() {
        let defaults = UserDefaults.standard
        
        // QR 전경색 (패턴 색)
        if let foregroundHex = defaults.string(forKey: QRDefaults.qrForegroundColor) {
            selectedForegroundColor = UIColor(hexString: foregroundHex)
        } else {
            selectedForegroundColor = .black // 기본값
        }
        
        // QR 배경색
        if let backgroundHex = defaults.string(forKey: QRDefaults.qrBackgroundColor) {
            selectedBackgroundColor = UIColor(hexString: backgroundHex)
        } else {
            selectedBackgroundColor = .white // 기본값
        }
        
        // QR 로고 색
        if let logoHex = defaults.string(forKey: QRDefaults.qrLogoColor) {
            selectedLogoColor = UIColor(hexString: logoHex)
        } else {
            selectedLogoColor = .black // 기본값
        }
        
        // QR 손상율 (기본 30%)
        if defaults.object(forKey: QRDefaults.qrDamageCorrection) != nil {
            selectedQRPercent = CGFloat(defaults.float(forKey: QRDefaults.qrDamageCorrection))
        } else {
            selectedQRPercent = 0.3
        }
        
        // QR 로고 도트 선명도 (기본 20)
        if defaults.object(forKey: QRDefaults.qrLogoDotSharpness) != nil {
            selectedDotVal = defaults.integer(forKey: QRDefaults.qrLogoDotSharpness)
        } else {
            selectedDotVal = 20
        }
        
        //QR 사이즈
        if let qrsizeString = defaults.string(forKey: QRDefaults.qrSize) {
            selectedSizeOption = qrsizeString
        } else {
            print("userDefaults 저장 안되어있음")
            selectedSizeOption = "900"
        }
    }
    
    private func updateColorSetting() {
        customizingView.color1Button.backgroundColor = selectedForegroundColor
        customizingView.color2Button.backgroundColor = selectedBackgroundColor
        customizingView.color3Button.backgroundColor = selectedLogoColor
        
        customizingView.logoDotSlider.value = Float(selectedDotVal)
        customizingView.qrSetSlider.value = Float(selectedQRPercent)
        
        customizingView.qrSetValueLabel.text = String(Int(customizingView.qrSetSlider.value * 100)) + "%"
        
        customizingView.logoDotValueLabel.text = String(Int(customizingView.logoDotSlider.value)) + "X" + "  (\(String(Int(customizingView.logoDotSlider.value) * 50)) * \(String(Int(customizingView.logoDotSlider.value) * 50)) Pixel)"
        
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
        saveQRSettings()
        delegate?.didSendDataBack((selectedQRPercent, selectedDotVal, selectedForegroundColor, selectedBackgroundColor, selectedLogoColor, selectedSizeOption, selectedEyeShape, selectedBodyShape))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoDotSliderValueChanged(_ sender: UISlider) {
        customizingView.logoDotValueLabel.text = String(Int(sender.value)) + "X" + "  (\(String(Int(sender.value) * 50)) * \(String(Int(sender.value) * 50)) Pixel)"
        selectedDotVal = Int(sender.value)
    }
    
    @IBAction func qrSetSliderValueChanged(_ sender: UISlider) {
        customizingView.qrSetValueLabel.text = String(Int(sender.value * 100)) + "%"
        selectedQRPercent = CGFloat(sender.value)
    }
    
    func saveQRSettings() {
        let defaults = UserDefaults.standard
        
        defaults.set(selectedForegroundColor.toHexString(), forKey: QRDefaults.qrForegroundColor)
        defaults.set(selectedBackgroundColor.toHexString(), forKey: QRDefaults.qrBackgroundColor)
        defaults.set(selectedLogoColor.toHexString(), forKey: QRDefaults.qrLogoColor)
        defaults.set(Float(selectedQRPercent), forKey: QRDefaults.qrDamageCorrection)
        defaults.set(selectedDotVal, forKey: QRDefaults.qrLogoDotSharpness)
        defaults.set(selectedSizeOption, forKey: QRDefaults.qrSize)
        
        print("✅ QR 설정 저장 완료!")
    }
    
    @IBAction func colorInfoButtonTapped(_ sender: UIButton) {
        show(titleLabel: "QR 코드 색상 안내", contentLabel: "QR코드는 일반적으로 전경색을 검은색, 배경색을 흰색이 기본적이지만, 다른 색상으로 설정할 수 있습니다.", tipLabel: "1. 전경색은 배경색과 충분한 대비를 이루어야 QR 코드 인식이 원활합니다.\n\n2. 배경색이 너무 어두우면 인식률이 낮아질 수 있습니다.\n\n3. 투명한 배경보다는 단색 배경이 인식률을 높이는 데 유리합니다.")
    }
    
    
    @IBAction func damageRateInfoButtonTapped(_ sender: UIButton) {
        show(titleLabel: "QR 코드 손상률 안내", contentLabel: "QR코드의 손상률은 QR코드의 중앙에 들어가는 로고의 크기를 결정합니다.", tipLabel: "1. 손상률이 높을수록(최대 30%) QR코드의 복원력이 증가하지만, 로고 크기는 작아집니다.\n\n2. 손상률이 낮을수록 로고를 크게 넣을 수 있지만, 인식률이 감소할 수 있습니다.\n\n3. 일반적으로 10 ~ 30%의 손상률을 설정합니다.")
    }
    
    
    @IBAction func logoRateInfoButtonTapped(_ sender: UIButton) {
        show(titleLabel: "QR 코드 로고 선명도 안내", contentLabel: "로고의 선명도는 QR 코드의 중앙에 들어갈 로고의 도트 뭉개짐 정도입니다.", tipLabel: "1. 로고 도트의 선명도가 높을수록, 로고의 원본 이미지와 비슷하게 출력됩니다.\n\n2. 로고의 복잡한 이미지는 도트화 과정에서 세부 사항이 손실될 수 있으므로 단순한 디자인이 유리합니다.")
    }
    
    
    
}

//MARK: - ColorPicker
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

//MARK: - PickerView
extension CustomizingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPickerViews() {
        customizingView.qrsizeTF.text = "\(selectedSizeOption) X \(selectedSizeOption) 픽셀"
        
        let sizePicker = UIPickerView()
        sizePicker.delegate = self
        sizePicker.dataSource = self
        
        customizingView.qrsizeTF.inputView = sizePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        customizingView.qrsizeTF.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(sizeOptions[row]) X \(sizeOptions[row]) 픽셀"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSizeOption = sizeOptions[row]
        customizingView.qrsizeTF.text = "\(selectedSizeOption) X \(selectedSizeOption) 픽셀"
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
}

//MARK: - CollectionView

extension CustomizingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == customizingView.eyeShapeCollectionView {
           return self.eyeShapes.count
        } else {
            return self.bodyShapes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == customizingView.eyeShapeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as?
                    EyeShapeCollectionViewCell else {
                return UICollectionViewCell() }
            
            let target = self.eyeShapes[indexPath.row]
            
            // 버튼 이미지 렌더링
            cell.eyeShapeImageButton.setImage(UIImage(named: "\(target)")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier2, for: indexPath) as?
                    BodyShapeCollectionViewCell else {
                return UICollectionViewCell() }
            
            let target = self.bodyShapes[indexPath.row]
            
            cell.bodyShapeImageButton.setImage(UIImage(named: "\(target)")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 40
        let height = 40
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == customizingView.eyeShapeCollectionView {
            let target = self.eyeShapes[indexPath.row]
            print(target)
            
            
        } else {
            let target = self.bodyShapes[indexPath.row]
            print(target)
            
        }
        
    }

    
}

extension UIColor {
    // UIColor → HEX String 변환
    func toHexString() -> String {
        guard let components = self.cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    // HEX String → UIColor 변환
    convenience init(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

//
//  PrivacyViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 2/28/25.
//

import UIKit
import PDFKit

class PrivacyViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPdfView()
    }
    
    func loadPdfView(document: PDFDocument) {
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = document
    }
    

    func setPdfView() {
        view.backgroundColor = CustomColor.darkModeBackgroundColor.color
        let url = Bundle.main.url(forResource: "[QR]개인정보처리방침", withExtension: "pdf")
        
        let document = PDFDocument(url: url!)
        loadPdfView(document: document!)
    }


}

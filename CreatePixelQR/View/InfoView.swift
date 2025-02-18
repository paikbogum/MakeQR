//
//  InfoView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 2/18/25.
//

import UIKit

class InfoView: UIView {

    @IBOutlet weak var infoTableView: UITableView!
    
    
    func setUI() {
        self.backgroundColor = CustomColor.darkModeBackgroundColor.color
        
        infoTableView.backgroundColor = .clear
    }
    
}

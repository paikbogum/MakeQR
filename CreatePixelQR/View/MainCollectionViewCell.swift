//
//  MainCollectionViewCell.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryExplainText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = .white
            
        categoryExplainText.font = UIFont.boldSystemFont(ofSize: 15)
        categoryExplainText.textColor = .black
    }

}

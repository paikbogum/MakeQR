//
//  MainCollectionViewCell.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/24/24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

   // @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryExplainText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .white
        contentView.backgroundColor = CustomColor.backgroundColor.color
    
        categoryExplainText.font = UIFont.boldSystemFont(ofSize: 15)
        categoryExplainText.textColor = .black
    }

}

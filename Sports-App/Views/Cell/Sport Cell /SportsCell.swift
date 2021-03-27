//
//  SportsCell.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import UIKit

class SportsCell: UICollectionViewCell {
    
    @IBOutlet weak var SportImageView: UIImageView!
    @IBOutlet weak var SportNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        MakeItCricle(image: SportImageView)
        
    }
    
    func MakeItCricle(image: UIImageView) {
        image.layer.cornerRadius = (image.layer.frame.width / 2)
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0
        
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 47
        image.layer.shadowOffset = .zero
        image.layer.shadowRadius = (image.layer.frame.width / 2)
    }

}

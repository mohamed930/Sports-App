//
//  SportsCell.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import UIKit

class SportsCell: UICollectionViewCell {
    
    @IBOutlet weak var SportImageView: UIImageView!
    @IBOutlet weak var ContianerView: UIView!
    @IBOutlet weak var SportNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        SportImageView.applyshadowWithCorner(containerView: ContianerView , cornerRadious: (self.SportImageView.layer.frame.width / 2), shadowColor: "#020202")
        
    }
    
//    func MakeItCricle(image: UIImageView , ShadowColor: String) {
//        image.layer.cornerRadius = (image.layer.frame.width / 2)
//        image.layer.masksToBounds = true
//        image.clipsToBounds = false
//        image.layer.borderWidth = 0
//
//        image.layer.shadowColor = UIColor().hexStringToUIColor(hex: ShadowColor).cgColor
//        image.layer.shadowOpacity = 12
//        image.layer.shadowOffset = .zero
//        image.layer.shadowRadius = (image.layer.frame.width / 2)
//    }

}

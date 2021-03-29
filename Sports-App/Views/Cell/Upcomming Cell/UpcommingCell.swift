//
//  UpcommingCell.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import UIKit

class UpcommingCell: UICollectionViewCell {
    
    @IBOutlet weak var EventTumbnailImageView: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var EventNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        MakeItCricle(image: EventTumbnailImageView)
//        self.contentView.layer.cornerRadius = 9
//        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.borderWidth = 0
    }

    func MakeItCricle(image: UIImageView) {
        image.layer.cornerRadius = 9
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0

    }
    
}

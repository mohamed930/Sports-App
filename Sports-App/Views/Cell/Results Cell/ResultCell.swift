//
//  ResultCell.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import UIKit

class ResultCell: UICollectionViewCell {
    
    @IBOutlet weak var Team1Label: UILabel!
    @IBOutlet weak var Team2Label: UILabel!
    @IBOutlet weak var Team1ScoreLabel: UILabel!
    @IBOutlet weak var Team2ScoreLabel: UILabel!
    @IBOutlet weak var LeagueNameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var StadiumNameLabel: UILabel!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var StatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ContainerView.layer.cornerRadius = 9
        ContainerView.layer.masksToBounds = true
        ContainerView.layer.borderWidth = 0
        
    }

}

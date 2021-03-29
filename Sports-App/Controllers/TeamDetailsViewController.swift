//
//  TeamDetailsViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import UIKit
import RappleProgressHUD
import Kingfisher

class TeamDetailsViewController: UIViewController {
    
    @IBOutlet weak var CoverImageView: UIImageView!
    @IBOutlet weak var TeamBadgeImageView: UIImageView!
    @IBOutlet weak var TeamTitleLabel: UILabel!
    @IBOutlet weak var StadiumLabel: UILabel!
    @IBOutlet weak var LeagueNameLabel: UILabel!
    @IBOutlet weak var DetailsTextArea: UITextView!
    
    // MARK:- TODO:- Instialise new variable HERE:-
    var TeamID = String()
    var LinkFaceBook = String()
    var LinkIntegram = String()
    var LinkTwitter = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        LoadTeamDetails()
    }
    
    func LoadTeamDetails() {
        
        let ob = TeamsAPI()
        
        ob.GetTeamDetials(TeamID: TeamID) { (response) in
            
            switch response {
            
            case .success(let res):
                
                DispatchQueue.main.async {
                    
                    self.CoverImageView.kf.setImage(with:URL(string: (res?.teams[0].strTeamFanart1 ?? "NO Image")))
                    self.TeamBadgeImageView.kf.setImage(with: URL(string: (res?.teams[0].strTeamBadge)!))
                }
                
                self.TeamTitleLabel.text = res?.teams[0].strTeam
                self.StadiumLabel.text = res?.teams[0].strStadium
                self.LeagueNameLabel.text = res?.teams[0].strLeague
                self.DetailsTextArea.text = res?.teams[0].strDescriptionEN
            
                self.LinkFaceBook = (res?.teams[0].strFacebook ?? "No URL")
                self.LinkTwitter = (res?.teams[0].strTwitter ?? "No URL")
                self.LinkIntegram = (res?.teams[0].strInstagram ?? "No URL")
                
                RappleActivityIndicatorView.stopAnimation()
            
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                RappleActivityIndicatorView.stopAnimation()
            }
            
        }
        
    }
    
    @IBAction func BTNDismiss (_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
}

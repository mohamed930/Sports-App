//
//  TeamDetailsViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import UIKit
import RappleProgressHUD
import Kingfisher
import SafariServices

class TeamDetailsViewController: UIViewController {
    
    @IBOutlet weak var CoverImageView: UIImageView!
    @IBOutlet weak var TeamBadgeImageView: UIImageView!
    @IBOutlet weak var TeamTitleLabel: UILabel!
    @IBOutlet weak var StadiumLabel: UILabel!
    @IBOutlet weak var LeagueNameLabel: UILabel!
    @IBOutlet weak var DetailsTextArea: UITextView!
    @IBOutlet weak var BTNBack: UIButton!
    
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
                
               // print("F: \(res?.teams[0].strTeamFanart1)")
                
                if res?.teams[0].strTeamFanart1 == "" || res?.teams[0].strTeamFanart1 == "NO Image" || res?.teams[0].strTeamFanart1 == nil {
                   
                    self.CoverImageView.image = UIImage(named: "No_image1")
                    self.BTNBack.setBackgroundImage(UIImage(named: "backBlack"), for: .normal)
                    
                    DispatchQueue.main.async {
                        
                        self.TeamBadgeImageView.kf.setImage(with: URL(string: (res?.teams[0].strTeamBadge)!))
                    }
                }
                else {
                    
                    DispatchQueue.main.async {
                        
                        self.CoverImageView.kf.setImage(with:URL(string: (res?.teams[0].strTeamFanart1 ?? "NO Image")))
                        self.TeamBadgeImageView.kf.setImage(with: URL(string: (res?.teams[0].strTeamBadge)!))
                    }
                    
                }
                
                self.TeamTitleLabel.text = res?.teams[0].strTeam.localizedUppercase
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
    
    @IBAction func BTNFaceBook(_ sender:Any) {
        print("FL: \(self.LinkFaceBook)")
        
        CheckLinkAndViewIt(url: self.LinkFaceBook)
    }
    
    @IBAction func BTNTwitter(_ sender:Any) {
        print("FL: \(self.LinkTwitter)")
       
        CheckLinkAndViewIt(url: self.LinkTwitter)
    }
    
    @IBAction func BTNInstegram(_ sender:Any) {
        print("FL: \(self.LinkIntegram)")
        
        CheckLinkAndViewIt(url: self.LinkIntegram)
    }
   
    public func openSafari(Url: String) {
        let u = "HTTPS://\(Url)"
        let safariVC = SFSafariViewController(url: URL(string: u)!)
        self.present(safariVC, animated: true)
    }
    
    public func createAlert (Title:String , Mess:String , ob:UIViewController) {
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        ob.present(alert,animated:true,completion: nil)
    }
    
    func CheckLinkAndViewIt(url: String) {
       if url == "" || url == "nil" {
           createAlert(Title: "Attension", Mess: "There is no link to show to you", ob: self)
       }
       else {
           openSafari(Url: url)
       }
   }
}

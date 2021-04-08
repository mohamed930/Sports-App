//
//  LeaguesDetailsViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import UIKit
import RappleProgressHUD
import Kingfisher
import CoreData

class LeaguesDetailsViewController: UIViewController {

    @IBOutlet weak var LeagueLogo: UIImageView!
    @IBOutlet weak var LeagueTitleLabel: CustomUILabel!
    @IBOutlet weak var UpcommingCV: UICollectionView!
    @IBOutlet weak var EventsCV: UICollectionView!
    @IBOutlet weak var TeamsCV: UICollectionView!
    @IBOutlet weak var LoveButton: UIButton!
    
    // MARK:- TODO:- Intialise New Varibles HERE:-
    var PickedLeagueID = String()
    var LinkYoutube = String()
    var UpcommingEventsArr = Array<UpcommingEventsViewModel>()
    var ResultEvetnsArr = Array<LastEventsViewModel>()
    var AllTeamsArr = Array<AllTeamsViewModel>()
    var LovedFav = [NSManagedObject]()
    var currentIdex = 0
    var isInFav = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UpcommingCV.register(UINib(nibName: "UpcommingCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        EventsCV.register(UINib(nibName: "ResultCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        TeamsCV.register(UINib(nibName: "TeamsCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        print("lid: \(self.PickedLeagueID)")
        LoadLove()
        GetLeagueDetails()
        //GetUpcommingEvents()
        
    }
    
    @IBAction func BTNBack (_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNLove (_ sender:Any) {
        
        if isInFav == false {
            
            // MARK:- TODO:- Add League to CoreDate.
            AddData()
        }
        else if isInFav == true {
            
            // MARK:- TODO:- Delete League from CoreData.
            DeleteData()
        }
    }
    
    func GetLeagueDetails () {
        
        let ob = LeaguesAPI()
        
        ob.GetLeagueDetails(id: PickedLeagueID) { (reponse) in
            switch reponse {
            
            case .success(let res):
                
                self.LeagueTitleLabel.text = res?.leagues[0].strLeagueName
                DispatchQueue.main.async {
                    self.LeagueLogo.kf.setImage(with:URL(string: (res?.leagues[0].strBadge)!))
                }
                self.LinkYoutube = (res?.leagues[0].strYoutube)!
//                RappleActivityIndicatorView.stopAnimation()
                
                // Add Action Here:-
                var tab = UITapGestureRecognizer()
                tab = UITapGestureRecognizer(target: self, action: #selector(self.gotoLink(tapGestureRecognizer:)))
                tab.numberOfTapsRequired = 1
                tab.numberOfTouchesRequired = 1
                self.LeagueTitleLabel.isUserInteractionEnabled = true
                self.LeagueTitleLabel.addGestureRecognizer(tab)
                
                self.GetUpcommingEvents()
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                RappleActivityIndicatorView.stopAnimation()
            }
        }
        
    }
    
    func GetUpcommingEvents() {
        
        let ob = EventsAPI()
        
        ob.GetAllEvents(id: self.PickedLeagueID) { (response) in
            
            switch response {
            
            case .success(let res):
                
                for i in (res?.events)! {
                    
                    let ob = UpcommingEventsViewModel(strEvent: i.strEvent, strThumb: i.strThumb ?? "No_image", dateEvents: i.dateEvent)
                    self.UpcommingEventsArr.append(ob)
                    self.UpcommingCV.reloadData()
                    
                    let ob1 = LastEventsViewModel(dateEvent: i.dateEvent ,strHomeTeam: i.strHomeTeam, strAwayTeam: i.strAwayTeam, strLeague: i.strLeague, intHomeScore: i.intHomeScore, intAwayScore: i.intAwayScore, strTime: i.strTime, strVenue: i.strVenue ?? "Unknown", strStatus: i.strStatus ?? "Not Started")
                    self.ResultEvetnsArr.append(ob1)
                    self.EventsCV.reloadData()
                }
                
                self.GetTeamsInALeague()
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                RappleActivityIndicatorView.stopAnimation()
            }
            
        }
        
    }
    
    func GetTeamsInALeague() {
        
        let ob = TeamsAPI()
        
        ob.GetAllTeams(LeagueName: self.LeagueTitleLabel.text!) { (respone) in
            
            switch respone {
            
            case .success(let res):
                
                for i in (res?.teams)! {
                    let ob = AllTeamsViewModel(idTeam: i.idTeam, strTeam: i.strTeam, strTeamBadge: i.strTeamBadge ?? "NoImage")
                    self.AllTeamsArr.append(ob)
                    self.TeamsCV.reloadData()
                }
                RappleActivityIndicatorView.stopAnimation()
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                RappleActivityIndicatorView.stopAnimation()
            }
            
        }
        
    }
    
    // MARK:- TODO:- CoreData Methods:-
    // --------------------------------------------
    func LoadLove () {
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Leagues")
         do {
            LovedFav = try context.fetch(fetchRequest)
         } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
         }
        
        var count = 0
        for i in LovedFav {
            if i.value(forKeyPath: "leagueid") as? String == self.PickedLeagueID {
                self.LoveButton.setBackgroundImage(UIImage(named: "heart_red"), for: .normal)
                self.currentIdex = count
                self.isInFav = true
                break
            }
            count += 1
        }
        
    }
    
    func AddData () {
        let entity = NSEntityDescription.entity(forEntityName: "Leagues", in: context)!
        let league = NSManagedObject(entity: entity,insertInto: context)
        
        league.setValue(self.PickedLeagueID , forKeyPath: "leagueid")
        league.setValue(self.LeagueTitleLabel.text! , forKeyPath: "leaguetitle")
        
        do {
            try context.save()
            print("Added Successfully!")
            self.LoadLove()
            self.LoveButton.setBackgroundImage(UIImage(named: "heart_red"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Added"), object: self)
        } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func DeleteData () {
        
        context.delete(LovedFav[self.currentIdex] as NSManagedObject)
        
        do {
            try context.save()
            print("Deleted Successfully!")
            self.isInFav = false
            LoveButton.setBackgroundImage(UIImage(named: "BTNLove"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Added"), object: self)
        } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    // --------------------------------------------
    
    @objc func gotoLink(tapGestureRecognizer: UITapGestureRecognizer) {
//        print("Link Youtube: \(self.LinkYoutube)")
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "YoutubeViewViewController") as! YoutubeViewViewController
        next.youtubeLink = self.LinkYoutube
        //next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
}

extension LeaguesDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 3 {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let next = story.instantiateViewController(withIdentifier: "TeamDetailsViewController") as! TeamDetailsViewController
            next.TeamID = self.AllTeamsArr[indexPath.row].idTeam
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
        
    }
}

extension LeaguesDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return UpcommingEventsArr.count
        }
        else if collectionView.tag == 2 {
            return ResultEvetnsArr.count
        }
        else {
            return AllTeamsArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell: UpcommingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UpcommingCell
            
            cell.EventNameLabel.text = UpcommingEventsArr[indexPath.row].strEvent
            cell.DateLabel.text = UpcommingEventsArr[indexPath.row].dateEvents
            
            DispatchQueue.main.async {
                
                if (self.UpcommingEventsArr[indexPath.row].strThumb == "" || self.UpcommingEventsArr[indexPath.row].strThumb == "No_image") {
                    cell.EventTumbnailImageView.image = UIImage(named: "No_image")
                    cell.EventNameLabel.textColor = UIColor.black
                    cell.DateLabel.textColor = UIColor.black
                }
                else {
                    cell.EventTumbnailImageView.kf.setImage(with:URL(string: self.UpcommingEventsArr[indexPath.row].strThumb))
                }
                
                
            }
            
            return cell
        }
        else if collectionView.tag == 2 {
            
            let cell: ResultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ResultCell
            
            let results = ResultEvetnsArr[indexPath.row]
            
            cell.Team1Label.text = results.strHomeTeam
            cell.Team1ScoreLabel.text = results.intHomeScore
            cell.Team2Label.text = results.strAwayTeam
            cell.Team2ScoreLabel.text = results.intAwayScore
            
            cell.StatusLabel.text = results.strStatus
            cell.LeagueNameLabel.text = results.strLeague
            
            cell.DateLabel.text = results.dateEvent
            cell.TimeLabel.text = results.strTime
            if results.strVenue == "" {
                cell.StadiumNameLabel.text = "Unknown"
            }
            else {
                cell.StadiumNameLabel.text = results.strVenue
            }
            
            
            return cell
            
        }
        else {
            let cell: TeamsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TeamsCell
            
            cell.TeamNameLabel.text = AllTeamsArr[indexPath.row].strTeam
            
            if self.AllTeamsArr[indexPath.row].strTeamBadge == "" || self.AllTeamsArr[indexPath.row].strTeamBadge == "NoImage" {
                cell.TeamLogoImageView.image = UIImage(named: "No_image")
            }
            else {
                DispatchQueue.main.async {
                    cell.TeamLogoImageView.kf.setImage(with:URL(string: self.AllTeamsArr[indexPath.row].strTeamBadge))
                }
            }
            
            
            
            return cell
        }
    }
}

extension LeaguesDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
            IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            return CGSize(width: 189 , height: 75)
        }
        else if collectionView.tag == 2 {
            return CGSize(width: EventsCV.frame.width - 10 , height: 90)
        }
        else {
            let w1 = TeamsCV.frame.width - (15 * 2)
            let cell_width = (w1 - (15 * 2)) / 4
            
            return CGSize(width: cell_width, height: 75)
        }
        
    }
}

//
//  LeaguesViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import UIKit
import RappleProgressHUD

class LeaguesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Intialise New Varible Here:-
    var LeaguesArr = Array<LeaguesViewModel>()
    var PickedSportName = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LeagueCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        GetData()
    }
    
    @IBAction func BTNBack (_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func GetData() {
        
        let ob = LeaguesAPI()
        
        ob.GetAllLeagues { (response) in
            
            switch response {
            
            case .success(let res):
                
                for i in (res?.leagues)! {
                    
                    if i.SportType == self.PickedSportName {
                        
                        let ob = LeaguesViewModel(LeagueName: i.LeagueTitle, LeagueID: i.id)
                        self.LeaguesArr.append(ob)
                        self.tableView.reloadData()
                    }
                    
                }
                RappleActivityIndicatorView.stopAnimation()
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                RappleActivityIndicatorView.stopAnimation()
            }
            
        }
        
    }
    
}

extension LeaguesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next  = story.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as! LeaguesDetailsViewController
        next.PickedLeagueID = self.LeaguesArr[indexPath.row].LeagueID
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
        
    }
    
}

extension LeaguesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LeaguesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LeagueCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeagueCell
        
        cell.LeagueNameLabel.text = LeaguesArr[indexPath.row].LeagueName
        
        return cell
        
    }
    
    
}

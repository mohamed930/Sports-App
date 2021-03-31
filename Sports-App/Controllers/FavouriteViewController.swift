//
//  FavouriteViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/30/21.
//

import UIKit
import CoreData
import Reachability

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- TODO:- Insialise new varibles Here:-
    var LovedFav = [NSManagedObject]()
    var isConnectionAvaliable = true
    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LeagueCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        reachability.whenReachable = { reachability in
            
            if reachability.connection == .wifi || reachability.connection == .cellular {
                self.isConnectionAvaliable = true
            }
        }
        reachability.whenUnreachable = { _ in
            self.isConnectionAvaliable = false
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        LoadLove()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTestNotification), name: NSNotification.Name(rawValue: "Added"), object: nil)
    }
    
    func LoadLove () {
        
        self.LovedFav.removeAll()
        
        print("Received Successfully!")
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Leagues")
         do {
            LovedFav = try context.fetch(fetchRequest)
            self.tableView.reloadData()
         } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
         }
    }
    
    @objc func receiveTestNotification() {
        LoadLove()
    }

}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LovedFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LeagueCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeagueCell
        
        let league = LovedFav[indexPath.row]
        
        cell.LeagueNameLabel.text = league.value(forKeyPath: "leaguetitle") as? String
        
        return cell
        
    }
    
    
}

extension FavouriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isConnectionAvaliable == true {
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let next  = story.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as! LeaguesDetailsViewController
            next.PickedLeagueID = (self.LovedFav[indexPath.row].value(forKeyPath: "leagueid") as? String)!
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
            
        }
        else {
            createAlert(Title: "Error", Mess: "No Internet Connection", ob: self)
        }
        
    }
    
    public func createAlert (Title:String , Mess:String , ob:UIViewController) {
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        ob.present(alert,animated:true,completion: nil)
    }
    
}

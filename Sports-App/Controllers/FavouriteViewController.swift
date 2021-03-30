//
//  FavouriteViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/30/21.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var LovedFav = [NSManagedObject]()
    var isConnectionAvaliable = true

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LeagueCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        LoadLove()
    }
    
    func LoadLove () {
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Leagues")
         do {
            LovedFav = try context.fetch(fetchRequest)
         } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
         }
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

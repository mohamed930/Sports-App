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
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var LeaguesTrailing: NSLayoutConstraint!
    @IBOutlet weak var LeaguesLeading: NSLayoutConstraint!
    @IBOutlet weak var TextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var SearchTextField: UITextField!
    
    // MARK:- Intialise New Varible Here:-
    var LeaguesArr = Array<LeaguesViewModel>()
    var FiletedSportsArr = Array<LeaguesViewModel>()
    var PickedSportName = String()
    var filtered = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LeagueCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        GetData()
    }
    
    @IBAction func BTNBack (_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNSearch (_ sender:Any) {
        if TextFieldWidth.constant == 0 {
            UIView.animate(withDuration: 0.7) {
                self.TextFieldWidth.constant = (self.ContainerView.layer.frame.width) - 25
                self.LeaguesLeading.constant = 10
                self.LeaguesTrailing.constant = 15
                self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter League name", Color: UIColor.white)
                self.SearchTextField.becomeFirstResponder()
                self.view.layoutIfNeeded()
            }
        }
        else {
            print("Search is Done!")
        }
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
    
    func PlaceHolder (textField:UITextField,PlaceHolder:String , Color:UIColor) {
        textField.attributedPlaceholder = NSAttributedString(string: PlaceHolder,
                attributes: [NSAttributedString.Key.foregroundColor: Color])
    }
    
     func DismissKeyPad() {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.7) {
            self.TextFieldWidth.constant = 0
            self.LeaguesLeading.constant = 124
            self.LeaguesTrailing.constant = 151.67
            //self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter League name", Color: UIColor.white)
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DismissKeyPad()
    }
    
}

extension LeaguesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next  = story.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as! LeaguesDetailsViewController
        
        if !FiletedSportsArr.isEmpty {
            next.PickedLeagueID = self.FiletedSportsArr[indexPath.row].LeagueID
        }
        else {
            next.PickedLeagueID = self.LeaguesArr[indexPath.row].LeagueID
        }
        
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
        
    }
    
}

extension LeaguesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !FiletedSportsArr.isEmpty {
            return FiletedSportsArr.count
        }
        return filtered ? 0 : LeaguesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LeagueCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeagueCell
        
        if !FiletedSportsArr.isEmpty {
            cell.LeagueNameLabel.text = FiletedSportsArr[indexPath.row].LeagueName
        }
        else {
            cell.LeagueNameLabel.text = LeaguesArr[indexPath.row].LeagueName
        }
        
        return cell
        
    }
    
    
}

extension LeaguesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DismissKeyPad()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            
            if string.count == 0 {
                filterText(String(text.dropLast()))
            }
            else {
                filterText(text+string)
            }
        }
        
        return true
    }
    
    func filterText (_ query: String) {
        FiletedSportsArr.removeAll()
        
        for string in LeaguesArr {
            if string.LeagueName.lowercased().starts(with: query.lowercased()) {
                FiletedSportsArr.append(string)
            }
        }
        self.tableView.reloadData()
        filtered = true
    }
}



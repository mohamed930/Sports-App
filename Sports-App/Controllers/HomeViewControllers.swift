//
//  ViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import UIKit
import RappleProgressHUD
import Kingfisher
import Reachability

class HomeViewControllers: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- TODO:- Insialise New Varibles Here:-
    var SportsArr = Array<SportsViewModel>()
    var FiletedSportsArr = Array<SportsViewModel>()
    let reachability = try! Reachability()
    @IBOutlet weak var SearchWidth: NSLayoutConstraint!
    @IBOutlet weak var SportsLeading: NSLayoutConstraint!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SportsTrailing: NSLayoutConstraint!
    @IBOutlet weak var ContainerView: UIView!
    var timer: Timer?
    var timerCount: Int = 15
    var filtered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var tab = UITapGestureRecognizer()
//        tab = UITapGestureRecognizer(target: self, action: #selector(self.DismissKeyBad(tapGestureRecognizer:)))
//        tab.numberOfTapsRequired = 1
//        tab.numberOfTouchesRequired = 1
//        self.collectionView.isUserInteractionEnabled = true
//        self.collectionView.addGestureRecognizer(tab)
        
        collectionView.register(UINib(nibName: "SportsCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
          try reachability.startNotifier()
        }catch{
          print("could not start reachability notifier")
        }
        
    }
    
    @IBAction func BTNSearch (_ sender:Any) {
        
        if SearchWidth.constant == 0 {
            UIView.animate(withDuration: 0.7) {
                self.SearchWidth.constant = (self.ContainerView.layer.frame.width) - 40
                self.SportsLeading.constant = 30
                self.SportsTrailing.constant = 10
                self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter Sport name", Color: UIColor.white)
                self.SearchTextField.becomeFirstResponder()
                self.view.layoutIfNeeded()
            }
        }
        else {
            print("Search is Done!")
        }
        
    }
    
    func GetSportsData () {
        
        let ob = SportsAPI()
        
        ob.GetAllSports { (reponse) in
            
            switch reponse {
            
            case .success(let res):
                
                
                if (res?.sports.count)! > 0 {
                    
                    for i in (res?.sports)! {
                        
                        let newob = SportsViewModel(sportID: i.sportID , sportName: i.sportName , SportThumbnail: i.SportThumbnail ?? "No_image" , SportType: i.SportType)
                        
                        self.SportsArr.append(newob)
                        self.collectionView.reloadData()
                        
                    }
                    RappleActivityIndicatorView.stopAnimation()
                    
                }
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                RappleActivityIndicatorView.stopAnimation()
            }
            
        }
        
    }
    
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi:
            GetSportsData()
            reachability.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
      case .cellular:
            GetSportsData()
            reachability.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
      case .unavailable:
        print("Network not reachable")
        showAlertView()
        
      case .none:
        print("None")
      }
    }
    
    func showAlertView() {
        let alertController = UIAlertController(title: "Attention", message: "you are offline try reconnect", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Try again", style: .default) { (alert) in
            do{
                NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: .reachabilityChanged, object: self.reachability)
                try self.reachability.startNotifier()
            }catch{
              print("could not start reachability notifier")
            }
        }
        
        okAction.isEnabled = false

        alertController.addAction(okAction)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDownTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func countDownTimer() {
        timerCount -= 1

        let alertController = presentedViewController as! UIAlertController
        let okAction = alertController.actions.first

        if timerCount == 0 {
            timer?.invalidate()
            timer = nil

            okAction?.setValue("Ok", forKey: "title")
            okAction?.isEnabled = true
        } else {
            okAction?.setValue("Ok (\(timerCount))", forKey: "title")
        }
    }
    
    func PlaceHolder (textField:UITextField,PlaceHolder:String , Color:UIColor) {
        textField.attributedPlaceholder = NSAttributedString(string: PlaceHolder,
                attributes: [NSAttributedString.Key.foregroundColor: Color])
    }
    
     func DismissKeyPad() {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.7) {
            self.SearchWidth.constant = 0
            self.SportsLeading.constant = 166
            self.SportsTrailing.constant = 151.67
            //self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter Sport name", Color: UIColor.white)
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DismissKeyPad()
    }
    
//    @objc func DismissKeyBad (tapGestureRecognizer: UITapGestureRecognizer) {
//        DismissKeyPad()
//    }
}

extension HomeViewControllers: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !FiletedSportsArr.isEmpty {
            return FiletedSportsArr.count
        }
        return filtered ? 0 : SportsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SportsCell
        
        if !FiletedSportsArr.isEmpty {
            cell.SportNameLabel.text = FiletedSportsArr[indexPath.row].sportName
            
            if self.FiletedSportsArr[indexPath.row].SportThumbnail == "No_image" {
                cell.SportImageView.image = UIImage(named: "No_image")
            }
            else {
                DispatchQueue.main.async {
                    cell.SportImageView.kf.setImage(with:URL(string: self.FiletedSportsArr[indexPath.row].SportThumbnail))
                    
                }
            }
            
            
        }
        else {
            cell.SportNameLabel.text = SportsArr[indexPath.row].sportName
            
            if self.SportsArr[indexPath.row].SportThumbnail == "No_image" {
                cell.SportImageView.image = UIImage(named: "No_image")
            }
            else {
                DispatchQueue.main.async {
                    cell.SportImageView.kf.setImage(with:URL(string: self.SportsArr[indexPath.row].SportThumbnail))
                    
                }
            }
            
            
        }
        
        return cell
        
    }
    
    
}

extension HomeViewControllers: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "LeaguesViewController") as! LeaguesViewController
        
        if !FiletedSportsArr.isEmpty {
            next.PickedSportName = self.FiletedSportsArr[indexPath.row].sportName
        }
        else {
            next.PickedSportName = self.SportsArr[indexPath.row].sportName
        }
        
        
        next.modalPresentationStyle = .fullScreen
        
        self.present(next, animated: true, completion: nil)
        
    }
    
}

extension HomeViewControllers: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
            IndexPath) -> CGSize {
            
        let w1 = collectionView.frame.width - (22 * 2)
        let cell_width = (w1 - (22 * 2)) / 2
        
        return CGSize(width: cell_width, height: 165)
    }
}

extension HomeViewControllers: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.DismissKeyPad()
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
        
        for string in SportsArr {
            if string.sportName.lowercased().starts(with: query.lowercased()) {
                FiletedSportsArr.append(string)
            }
        }
        self.collectionView.reloadData()
        filtered = true
    }
    
}

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
    let reachability = try! Reachability()
    var timer: Timer?
    var timerCount: Int = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "SportsCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
          try reachability.startNotifier()
        }catch{
          print("could not start reachability notifier")
        }
        
        
        
    }
    
    func GetSportsData () {
        
        let ob = SportsAPI()
        
        ob.GetAllSports { (reponse) in
            
            switch reponse {
            
            case .success(let res):
                
                
                if (res?.sports.count)! > 0 {
                    
                    for i in (res?.sports)! {
                        
                        let newob = SportsViewModel(sportID: i.sportID , sportName: i.sportName , SportThumbnail: i.SportThumbnail , SportType: i.SportType)
                        
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
        let alertController = UIAlertController(title: "Attentio", message: "you are offline try reconnect", preferredStyle: .alert)

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
}

extension HomeViewControllers: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SportsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SportsCell
        
        cell.SportNameLabel.text = SportsArr[indexPath.row].sportName
        DispatchQueue.main.async {
            cell.SportImageView.kf.setImage(with:URL(string: self.SportsArr[indexPath.row].SportThumbnail))
            
        }
        
        return cell
        
    }
    
    
}

extension HomeViewControllers: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "LeaguesViewController") as! LeaguesViewController
        
        next.PickedSportName = self.SportsArr[indexPath.row].sportName
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

//
//  ViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import UIKit
import RappleProgressHUD
import Kingfisher

class HomeViewControllers: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- TODO:- Insialise New Varibles Here:-
    var SportsArr = Array<SportsViewModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "SportsCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        GetSportsData()
        
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

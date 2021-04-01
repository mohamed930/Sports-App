//
//  WelcomeViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 4/1/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var PaggineControl: UIPageControl!
    @IBOutlet weak var NextButton: UIButton!
    
    // MARK:- TODO:- Intialise New Varibles HERE:-
    let StringArr = [
        """
 Our App helps user to know information about
 any leagues you want
 """ ,
        """
 Show Details For your favorite team,
 encourage him with you know about it all information
 """,
        """
 Sea olds results in your favorite league,
 see your team results
 """
              ]
    let ImageArr = ["AllSports","Barchelona","ResultsImage"]
    var currentItem = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "WelcomCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        MakeRound(myView: NextButton, v: [.layerMinXMinYCorner])
    }
    
    @IBAction func BTNNext (_ sender: Any) {
        
        let nextItem = NSIndexPath(row: currentItem.row + 1, section: 0)
        
        if nextItem.row == 2 {
            NextButton.setTitle("let's do it", for: .normal)
        }
        
        if nextItem.row == 3 {
            print("Finished!")
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let next  = story.instantiateViewController(withIdentifier: "HomeTapBar")
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
            
        }
        else {
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        }
        
    }
    
    public func MakeRound(myView:AnyObject,v:CACornerMask) {
        //myView.clipsToBounds = true
        if #available(iOS 13.0, *) {
            myView.layer.cornerRadius = 27.0
        } else {
            // Fallback on earlier versions
        }
        
        /*
            top-right:    layerMaxXMinYCorner
            top-left:     layerMinXMinYCorner
            button-right: layerMaxXMaxYCorner
            button-left:  layerMinXMaxYCorner
         */
        if #available(iOS 13.0, *) {
            myView.layer.maskedCorners = v
        } else {
            // Fallback on earlier versions
        }
    }
}

extension WelcomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StringArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WelcomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WelcomCell
        
        cell.TitleLabel.text = StringArr[indexPath.row]
        cell.CoverImageView.image = UIImage(named: ImageArr[indexPath.row])
        
        return cell
    }
    
    
}

extension WelcomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.currentItem = indexPath
        if indexPath.row == 2 {
            print("Finished")
            NextButton.setTitle("let's do it", for: .normal)
        }
        else {
            NextButton.setTitle("Next", for: .normal)
        }
        self.PaggineControl.currentPage = indexPath.row
    }
    
}


extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        
         return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

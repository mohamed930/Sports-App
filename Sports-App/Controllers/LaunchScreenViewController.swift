//
//  LaunchScreenViewController.swift
//  Sports-App
//
//  Created by Mohamed Ali on 4/1/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var WaitImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        WaitImageView.loadGif(name: "launch")
        
        // .now()+1.54
        DispatchQueue.main.asyncAfter(deadline: .now()+2.6) {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let next  = story.instantiateViewController(withIdentifier: "WelcomeViewController")
            next.modalPresentationStyle = .fullScreen
            next.modalTransitionStyle   = .partialCurl
            self.present(next, animated: true, completion: nil)
        }
    }
}

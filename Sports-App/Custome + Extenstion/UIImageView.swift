//
//  UIImageView.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import UIKit

extension UIImageView {
    
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat , shadowColor: String){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor().hexStringToUIColor(hex: shadowColor).cgColor
        containerView.layer.shadowOpacity = 47
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
    
}

//
//  SportsAPI.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import Foundation
import RappleProgressHUD

protocol SportsAPIProtcol {
    func GetAllSports (completion: @escaping (Result<SportsResponse?,NSError>) -> Void)
}

class SportsAPI: BaseAPI<SportsNetworking>, SportsAPIProtcol {
    
    func GetAllSports (completion: @escaping (Result<SportsResponse?,NSError>) -> Void) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please wait", attributes: RappleModernAttributes)
        
        self.fetchData(Target: .GetSports , ClassName: SportsResponse.self) { (response) in
            completion(response)
        }
        
    }
    
}

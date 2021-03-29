//
//  LeaguesAPI.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation
import RappleProgressHUD


class LeaguesAPI: BaseAPI<LeaguesNetworking> {
    
    func GetAllLeagues (completion: @escaping (Result<LeaguesResponse?,NSError>) -> Void) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please wait", attributes: RappleModernAttributes)
        
        self.fetchData(Target: .getAllLeagues, ClassName: LeaguesResponse.self) { (response) in
            completion(response)
        }
        
    }
    
    func GetLeagueDetails (id: String,completion: @escaping (Result<LeaguesDetailsResponse?,NSError>) -> Void) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please wait", attributes: RappleModernAttributes)
        
        self.fetchData(Target: .getLeagueDetails(id: id), ClassName: LeaguesDetailsResponse.self) { (response) in
            completion(response)
        }
        
    }
    
}

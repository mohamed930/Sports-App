//
//  TeamsAPI.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation
import RappleProgressHUD

class TeamsAPI: BaseAPI<TeamsNetworking> {
    
    func GetAllTeams (LeagueName: String,completion: @escaping (Result<AllTeamsResponse?,NSError>) -> Void) {
        
        self.fetchData(Target: .ListAllTeamsInALeague(LeagueName: LeagueName), ClassName: AllTeamsResponse.self) { (reponse) in
            completion(reponse)
        }
        
    }
    
    func GetTeamDetials (TeamID: String , completion: @escaping (Result<AllTeamsResponse?,NSError>) -> Void) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please wait", attributes: RappleModernAttributes)
        
        self.fetchData(Target: .TeamDetailsInALeague(TeamID: TeamID), ClassName: AllTeamsResponse.self) { (response) in
            completion(response)
        }
        
    }
    
}

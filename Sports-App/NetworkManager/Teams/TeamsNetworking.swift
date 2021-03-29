//
//  TeamsNetworking.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation
import Alamofire

enum TeamsNetworking {
    
    case ListAllTeamsInALeague(LeagueName: String)
    case TeamDetailsInALeague (TeamID: String)
}

extension TeamsNetworking: TargetType {
    var baseURL: String {
        return baseurl
    }
    
    var path: String {
        
        switch self {
            
        case .ListAllTeamsInALeague:
            return ListAllTeamsURL
        case .TeamDetailsInALeague:
            return getTeamDetailsURL
        }
        
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        
        switch self {
            
        case .ListAllTeamsInALeague(LeagueName: let LeagueName):
            
            let params = ["l": LeagueName] as [String:Any]
            
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
            
        case .TeamDetailsInALeague(TeamID: let TeamID):
            
            let params = ["id": TeamID] as [String:Any]
            
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
        }
        
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}

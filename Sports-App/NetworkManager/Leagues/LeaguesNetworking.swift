//
//  LeaguesNetworking.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation
import Alamofire

enum LeaguesNetworking {
    
    case getAllLeagues
    case getLeagueDetails(id: String)
    
}

extension LeaguesNetworking: TargetType {
    
    var baseURL: String {
        return baseurl
    }
    
    var path: String {
        
        switch self {
        
        case .getAllLeagues:
            return AllLeaguesURL
        case .getLeagueDetails:
            return getDetailsLeagueURL
        }
        
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        
        switch self {
        
        case .getAllLeagues:
            return .requestPlain
        
        case .getLeagueDetails(id: let id):
            let parameters = ["id": id] as [String: Any]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding(destination: .queryString))
        }
        
    }
    
    var headers: [String : String]? {
        return [:]
    }
        
}

//
//  LeaguesNetworking.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

enum LeaguesNetworking {
    
    case getAllLeagues
    
}

extension LeaguesNetworking: TargetType {
    
    var baseURL: String {
        return baseurl
    }
    
    var path: String {
        
        switch self {
        
        case .getAllLeagues:
            return AllLeaguesURL
        }
        
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        
        switch self {
        
        case .getAllLeagues:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        return [:]
    }
        
}

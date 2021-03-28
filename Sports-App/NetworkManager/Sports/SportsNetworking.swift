//
//  SportsNetworking.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import Foundation
import Alamofire

enum SportsNetworking {
    
    case GetSports
    
}

extension SportsNetworking: TargetType {
    
    var baseURL: String {
        return baseurl
    }
    
    var path: String {
        return AllSportsURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        
        switch self {
            
        case .GetSports:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}

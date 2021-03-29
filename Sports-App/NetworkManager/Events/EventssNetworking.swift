//
//  EventssNetworking.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation
import Alamofire

enum EventssNetworking {
    case AllLastEnents(id: String)
}

extension EventssNetworking: TargetType {
    var baseURL: String {
        return baseurl
    }
    
    var path: String {
        return LastEventsURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        
        case .AllLastEnents(let id):
            let prams = ["id": id] as [String:Any]
            
            return .requestParameters(parameters: prams, encoding: URLEncoding(destination: .queryString))
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}

//
//  LeaguesResponse.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class LeaguesResponse: Codable {
    var leagues: [LeaguesModel]
    
    enum CodingKeys: String,CodingKey {
        case leagues
    }
    
    
}

//
//  LeaguesDetailsResponse.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class LeaguesDetailsResponse : Codable {
    var leagues: [LeaguesDetailsModel]
    
    enum CodingKeys: String,CodingKey {
        case leagues
    }
}

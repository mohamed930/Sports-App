//
//  LeaguesModel.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class LeaguesModel: Codable {
    
    var id: String
    var LeagueTitle: String
    var SportType: String
    
    enum CodingKeys: String,CodingKey {
        case id = "idLeague"
        case LeagueTitle = "strLeague"
        case SportType = "strSport"
    }
    
}

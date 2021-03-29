//
//  LeaguesDetailsModel.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class LeaguesDetailsModel: Codable {
    
    var strYoutube: String
    var strLeagueName: String
    var strBadge: String
    
    enum CodingKeys: String,CodingKey {
        case strYoutube
        case strLeagueName = "strLeague"
        case strBadge
    }
    
}

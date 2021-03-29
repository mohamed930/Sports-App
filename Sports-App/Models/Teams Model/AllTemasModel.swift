//
//  AllTemasModel.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class AllTemasModel: Codable {
    
    var idTeam: String
    var strTeam: String
    var strTeamBadge: String
    var strLeague: String
    var strStadium: String
    var strDescriptionEN: String
    var strFacebook: String?
    var strTwitter: String?
    var strInstagram: String?
    var strTeamFanart1: String?
    
    enum CodingKeys: String,CodingKey {
        case idTeam
        case strTeam
        case strTeamBadge
        case strLeague
        case strStadium
        case strDescriptionEN
        case strFacebook
        case strTwitter
        case strInstagram
        case strTeamFanart1
    }
    
}

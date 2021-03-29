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
    
    enum CodingKeys: String,CodingKey {
        case idTeam
        case strTeam
        case strTeamBadge
    }
    
}

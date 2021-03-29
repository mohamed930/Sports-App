//
//  AllTeamsResponse.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class AllTeamsResponse: Codable {
    var teams: [AllTemasModel]
    
    enum CodingKeys: String,CodingKey {
        case teams
    }
}

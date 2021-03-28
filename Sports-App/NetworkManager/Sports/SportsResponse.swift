//
//  SportsResponse.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import Foundation

class SportsResponse: Codable {
    
    var sports: [SportsModel]
    
    
    enum CodingKeys: String,CodingKey {
        case sports
    }
    
}

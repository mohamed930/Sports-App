//
//  SportsResponse.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import Foundation

class SportsModel: Codable {
    
    var sportID: String
    var sportName: String
    var SportThumbnail: String
    var SportType: String
    
    enum CodingKeys: String,CodingKey {
        case sportID = "idSport"
        case sportName = "strSport"
        case SportThumbnail = "strSportThumb"
        case SportType = "strFormat"
    }
    
}

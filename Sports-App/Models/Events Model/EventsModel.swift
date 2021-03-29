//
//  EventsModel.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class EventsModel: Codable {
    var strEvent: String
    var strThumb: String?
    var dateEvent: String
    
    var strHomeTeam: String
    var strAwayTeam: String
    var strLeague: String
    var intHomeScore: String?
    var intAwayScore: String?
    var strTime: String
    var strVenue: String?
    var strStatus: String?
    
    enum CodingKeys: String,CodingKey {
        case strEvent
        case strThumb
        case dateEvent
        case strHomeTeam
        case strAwayTeam
        case strLeague
        case intHomeScore
        case intAwayScore
        case strTime
        case strVenue
        case strStatus
    }
}

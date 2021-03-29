//
//  EventsResponse.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class EventsResponse: Codable {
    
    var events: [EventsModel]
    
    enum CodingKeys: String,CodingKey {
        case events
    }
    
}

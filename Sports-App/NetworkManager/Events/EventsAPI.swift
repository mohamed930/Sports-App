//
//  EventsAPI.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation

class EventsAPI: BaseAPI<EventssNetworking> {
    
    func GetAllEvents (id:String,completion: @escaping (Result<EventsResponse?,NSError>) -> Void) {
        
        self.fetchData(Target: .AllLastEnents(id: id), ClassName: EventsResponse.self) { (response) in
            completion(response)
        }
        
    }
    
}

//
//  ErrorResponse.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/27/21.
//

import Foundation

class ErrorResponse: Decodable {
    var status: String
    var error: String
    
    enum CodingKeys: String,CodingKey {
        case status
        case error
    }
}

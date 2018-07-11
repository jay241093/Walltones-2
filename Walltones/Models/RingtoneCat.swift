//
//  RingtoneCat.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/5/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import Foundation

struct RingtioneCat: Codable {
    let data: [RingtoneCategory]
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct RingtoneCategory: Codable {
    let id: Int
    let name, tabIcon: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case tabIcon = "tab_icon"
    }
}

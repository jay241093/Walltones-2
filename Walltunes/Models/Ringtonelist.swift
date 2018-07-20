//
//  Ringtonelist.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/5/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let ringtionelist = try? JSONDecoder().decode(Ringtionelist.self, from: jsonData)

import Foundation

struct Ringtionelist: Codable {
    let data: [Ringlist]
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct Ringlist: Codable {
    let id, name, itemID: String
    let description: String?
    let categoryName, file, icon: String
    var downloadCount: String?
    let keywords: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case itemID = "item_id"
        case description
        case categoryName = "category_name"
        case file, icon
        case downloadCount = "download_count"
        case keywords
    }
}



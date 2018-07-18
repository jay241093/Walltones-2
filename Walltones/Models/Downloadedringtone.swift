//
//  Downloadedringtone.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/16/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import Foundation

struct Downloadedringtone: Codable {
    let data: [DownRingtone]
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct DownRingtone: Codable,Hashable, Equatable {
    let id: String?
    let name: String?
    let itemID: String
    let description: String?
    let categoryName: String?
    let file, icon, downloadCount: String?
    let keywords: String?
    var hashValue: Int { get { return id!.hashValue } }

    
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
func ==(left:DownRingtone, right:DownRingtone) -> Bool {
    return left.id == right.id
}

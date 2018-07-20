//
//  Downloadedwallpaper.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/16/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import Foundation

struct Downloadedwallpaper: Codable {
    let data: [DownWallpaper]
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct DownWallpaper: Codable,Hashable, Equatable {
    let id, name, itemID: String?
    let description: String?
    let categoryName, file, icon, downloadCount: String?
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
func==(left:DownWallpaper, right:DownWallpaper) -> Bool {
    return left.id == right.id
}

//
//  WallpaperCategoryRes.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/4/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import Foundation

struct WallpaperCatRes: Codable {
    let data: [Datum]
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct Datum: Codable {
    let id: Int
    let name, tabIcon: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case tabIcon = "tab_icon"
    }
}

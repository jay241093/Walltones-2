//
//  File.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/4/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let wallpaperList = try? JSONDecoder().decode(WallpaperList.self, from: jsonData)
import Foundation

struct WallpaperList: Codable {
    let data: [Datum1]
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct Datum1: Codable {
    let id, name, itemID: String
    let description: String?
    let categoryName, file, icon, downloadCount: String?
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

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

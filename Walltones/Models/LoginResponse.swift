//
//  DriverMeResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 07/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation

 struct LoginResponse: Codable {
    let data: DataClass
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

 struct DataClass: Codable {
    let userID: Int
    let email, profilePic, username: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case profilePic = "profile_pic"
        case username
    }
}

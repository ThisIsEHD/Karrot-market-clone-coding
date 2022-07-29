//
//  User.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation

struct User: Codable {
    
    let id: String
    let pw: String?
    let nickName: String
    let name: String
    let phone: String?
    let profileImageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "email"
        case pw
        case nickName = "nickName"
        case name
        case phone
        case profileImageUrl = "profileImage"
    }
}

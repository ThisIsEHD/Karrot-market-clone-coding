//
//  User.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let nickName: String
    let profileImageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nickName = "nickName"
        case profileImageUrl = "profileImage"
    }
}

//
//  User.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation

struct User: Codable {

    let id: String?
    let email: String?
    let pw: String?
    let nickName: String?
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case id
        case pw
        case nickName = "nickname"
        case profileImageUrl = "profileImage"
    }
}

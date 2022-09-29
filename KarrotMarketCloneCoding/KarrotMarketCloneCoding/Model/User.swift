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
    let nickname: String?
    let profileImageUrl: String?
    
    init(id: String?, email: String? = nil, pw: String? = nil, nickname: String?, profileImageUrl: String? = nil) {
        self.id = id
        self.email = email
        self.pw = pw
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case id
        case pw
        case nickname
        case profileImageUrl = "profileImage"
    }
}

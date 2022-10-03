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
    
    init(id: String?, email: String?, pw: String?, nickname: String?, profileImageUrl: String?) {
        self.id = id
        self.email = email
        self.pw = pw
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
    
    init(id: String?, nickname: String?) {
        self.init(id: id, email: nil, pw: nil, nickname: nickname, profileImageUrl: nil)
    }
    
    init(email: String?, pw: String?) {
        self.init(id: nil, email: email, pw: pw, nickname: nil, profileImageUrl: nil)
    }
    
    init(email: String?, pw: String?, nickname: String?) {
        self.init(id: nil, email: email, pw: pw, nickname: nickname, profileImageUrl: nil)
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case id
        case pw
        case nickname
        case profileImageUrl = "profileImage"
    }
}

//
//  User.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation

struct User: Codable {
    let email: String?
    let password: String?
    let nickname: String?
    let profileImageURL: String?
    var userLocation: LocationInfo?
    
    init(email: String?, password: String?, nickname: String?, profileImageURL: String?, userLocation: LocationInfo?) {
        self.email = email
        self.password = password
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.userLocation = userLocation
    }
    /// 로그인
    init(email: String?, password: String?) {
        self.init(email: email, password: password, nickname: nil, profileImageURL: nil, userLocation: nil)
    }
    
    /// 회원가입
    init(email: String?, password: String?, nickname: String?, userLocation: LocationInfo?) {
        self.init(email: email, password: password, nickname: nickname, profileImageURL: nil, userLocation: userLocation)
    }
    
    /// 프로필 수정
    init(nickname: String, profileImageURL: String?) {
        self.init(email: nil, password: nil, nickname: nickname, profileImageURL: profileImageURL, userLocation: nil)
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case nickname
        case profileImageURL = "profileImage"
        case userLocation = "town"
    }
}

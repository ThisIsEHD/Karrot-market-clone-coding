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
    
    let chatroomId: Int?
    let userId: String?
    
    init(id: String?, email: String?, pw: String?, nickname: String?, profileImageUrl: String?, chatroomId: Int?, userId: String?) {
        self.id = id
        self.email = email
        self.pw = pw
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.chatroomId = chatroomId
        self.userId = userId
    }
    
    /// 로그인
    init(email: String?, pw: String?) {
        self.init(id: nil, email: email, pw: pw, nickname: nil, profileImageUrl: nil, chatroomId: nil, userId: nil)
    }
    
    /// 회원가입
    init(email: String?, pw: String?, nickname: String?) {
        self.init(id: nil, email: email, pw: pw, nickname: nickname, profileImageUrl: nil, chatroomId: nil, userId: nil)
    }
    
    /// 프로필 수정
    init(nickname: String?, profileImageUrl: String?) {
        self.init(id: nil, email: nil, pw: nil, nickname: nickname, profileImageUrl: profileImageUrl, chatroomId: nil, userId: nil)
    }
    
    init(chatroomId: Int?, userId: String?, nickname: String?, profileImageUrl: String?) {
        self.init(id: nil, email: nil, pw: nil, nickname: nickname, profileImageUrl: profileImageUrl, chatroomId: chatroomId, userId: userId)
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case id
        case pw
        case nickname
        case profileImageUrl = "profileImage"
        case chatroomId, userId
    }
}

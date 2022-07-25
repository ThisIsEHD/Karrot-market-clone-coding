//
//  User.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation

struct User: Codable {
    //domb : id가 이메일형식이라 타입바뀌어야하고, 속성값이 달라져야함 -> image 제거 phone, name추가
    let id: String
    let nickName: String
    let name: String
    let phone: String
    let profileImageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "email"
        case nickName = "nickName"
        case name
        case phone
        case profileImageUrl = "profileImage"
    }
}

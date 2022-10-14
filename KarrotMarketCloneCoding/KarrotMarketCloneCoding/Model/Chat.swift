//
//  Chat.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import Foundation

struct Chat: Codable {
    let size: Int
    let userId: String
    let chatrooms: [Chatroom]?
    
    enum CodingKeys: String, CodingKey {
        case size, userId, chatrooms
    }
}

struct Chatroom: Codable {
    let chatroomId: Int ///내가 참여하고있는 채팅방 id
    let productId: Int
    let product: Item
    let seller: ChatroomUserInfo
    let buyer: ChatroomUserInfo
    let lastChat: Message
    
    enum CodingKeys: String, CodingKey {
        case chatroomId = "id"
        case productId, product, seller, buyer, lastChat
    }
}

struct ChatroomUserInfo: Codable {
    let chatroomId: Int
    let userId: String
    let nickname: String
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case chatroomId, userId, nickname
        case profileImageUrl = "profileImage"
    }
}

struct Message: Codable {
    let text: String
    let sendDate: Date
    
    enum CodingKeys: String, CodingKey {
        case text = "content"
        case sendDate
    }
}

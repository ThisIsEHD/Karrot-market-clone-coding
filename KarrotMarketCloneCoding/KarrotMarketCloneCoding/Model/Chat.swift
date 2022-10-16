//
//  Chat.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import Foundation
import UIKit

/// 채팅방 목록 불러올떄 사용하는 객체
struct ChatList: Codable {
    let size: Int
    let userId: String
    let chat: [Chat]?
    
    enum CodingKeys: String, CodingKey {
        case size, userId
        case chat = "chatrooms"
    }
}

/// 단일 채팅정보를 불러올때 사용하는 객체
struct Chat: Codable {
    let chatroomId: Int ///내가 참여하고있는 채팅방 id
    let productId: Int
    let product: Item?
    let seller: ChatUserInfo?
    let buyer: ChatUserInfo?
    let lastChat: LastChat
    
    enum CodingKeys: String, CodingKey {
        case chatroomId = "id"
        case productId, product, seller, buyer, lastChat
    }
}

/// 단일 채팅정보에 담겨져있는 나와 상대방 정보를 저장하는 객체
///
///> domb: chatroomId는 User가 갖고있는 고유한 id가 아니라고 생각해 User와 별개로 ChatUser 모델을 하나 만들어줌. 그리고 User와는 id key값도 달라서 같이 사용할수 없을 것 같음.
struct ChatUserInfo: Codable {
    let chatroomId: Int
    let userId: String
    let nickname: String
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case chatroomId, userId, nickname
        case profileImageUrl = "profileImage"
    }
}

///Conversation View에 저장하여 따로 사용하는 User객체
struct ChatUser {
    let id: String
    let nickname: String
    let profileImage: UIImage?
    var isMe: Bool {
        let userId = UserDefaults.standard.object(forKey: Const.userId) as? String
        return userId == id
    }
    
    init(id: String, nickname: String, profileImage: UIImage?) {
        self.id = id
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

/// Message 객체
struct Message {
    let id: Int
    let user: ChatUser
    let body: String
    let sendDate: Date
}

///> domb: Message와 함께 쓸수는 없을까..
struct LastChat: Codable {
    let text: String
    let sendDate: Date
    
    enum CodingKeys: String, CodingKey {
        case text = "content"
        case sendDate
    }
}

///채팅방 스타일을 한번에 지정하여 사용할 수 있음
struct ChatStyle {
    
    var backgroundColor: UIColor = .white
    var inputViewBackgroundColor: UIColor = .white
    var inputTextViewBackgroundColor: UIColor = UIColor(white: 0.8, alpha: 0.2)
    
    var font: UIFont = .systemFont(ofSize: 16)
    var inputViewFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    var inputViewPlaceholder: String = "메세지 보내기"
    
    var inputViewTextColor: UIColor = .black
    var inputPlaceholderTextColor: UIColor = .systemGray3
    
    var inputTextViewTintColor: UIColor = .blue
    
    var outgoingTextColor: UIColor = .white
    var incomingTextColor: UIColor = .black
    
    var outgoingBubbleColor: UIColor = .appColor(.carrot)
    var incomingBubbleColor: UIColor = UIColor(white: 0.8, alpha: 0.2)
    
    var sendButtonTintColor: UIColor = UIColor(white: 0.6, alpha: 1)
    
    func size(for message: Message, in collectionView: UICollectionView) -> CGSize {

        var size: CGSize!

        let bubbleMessage = BubbleMessage()

        bubbleMessage.text = message.body
        bubbleMessage.font = font

        let bubbleSize = bubbleMessage.calculatedSize(in: CGSize(width: collectionView.bounds.width, height: .infinity))

        size = CGSize(width: collectionView.bounds.width, height: bubbleSize.height)

        return size
    }
    
    var inputViewTextContainerInset = UIEdgeInsets(top: 10, left: -2, bottom: 10, right: 0)
    var bubbleMessageContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
}


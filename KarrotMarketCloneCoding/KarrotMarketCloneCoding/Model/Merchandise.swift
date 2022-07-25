//
//  Merchandise.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation

struct Merchandise: Codable, Hashable {
    
    let ownerId: Int
    let id: Int
    let name: String
    let imageUrl: URL?
    let price: Int
    let wishCount: Int?
//    let chatCount: Int?
    let category: Int?
    let views: Int?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case ownerId = "userId"
        case id
        case name = "title"
        case imageUrl = "url"
        case price
        case wishCount = "wishes"
//        case chatCount
        case category = "categoryId"
        case views
        case content
    }
}

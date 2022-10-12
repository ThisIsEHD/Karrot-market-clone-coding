//
//  Item.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation
import UIKit

struct FetchedItemsList: Codable, Hashable {
    
    let keyword: String?
    let category: Int?
    let size: Int
    let items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case keyword, category, size
        case items = "products"
    }
}

// MARK: - Item

struct Item: Codable {
    
    var id: Int?
    var title: String?
    var content: String?
    var categoryId: Int?
    var price: Int?
    let regdate: String? //일단여기 잠깐 string
    let views: Int?
    let wishes: Int?
    let userId: String?
    let nickname: String?
    let profileImage: String?
    let thumbnail: String?
    var images: [Image]?
}

extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Image

struct Image: Codable, Hashable {
    
    let id, itemID, sequence: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case itemID = "productId"
        case id, url, sequence
    }
}

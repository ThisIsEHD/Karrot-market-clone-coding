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
        case Items = "products"
    }
}

// MARK: - Product
struct Item: Codable {
    let id: Int
    let title: String
    let price: Int?
    let regdate: String //일단여기 잠깐 string
    let views: Int?
    let wishes: Int
    let images: [Image]
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
        case ItemID = "productId"
        case id, url, sequence
    }
}

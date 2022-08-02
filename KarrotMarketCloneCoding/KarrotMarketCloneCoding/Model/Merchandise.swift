//
//  Merchandise.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation
import UIKit

struct FetchedMerchandise: Codable, Hashable {
    
    let keyword: String?
    let size: Int
    let category: Int?
    let id: Int
    let name: String
    let imageUrl: String?
    let price: Int
    let wishCount: Int?
    //    let chatCount: Int?
    
    let views: Int?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case size
        case category = "categoryId"
        case id
        case name = "title"
        case imageUrl = "url"
        case price
        case wishCount = "wishes"
        //        case chatCount
        
        case views
        case content
    }
}

struct FetchedMerchandisesList: Codable, Hashable {
    let keyword: String?
    let category: Int?
    let merchandises: [Merchandise]
    let size: Int
    
    enum CodingKeys: String, CodingKey {
        case keyword, category, size
        case merchandises = "products"
    }
}

// MARK: - Product
struct Merchandise: Codable {
    let id: Int
    let title: String
    let price: Int
    let userID: String
    let regdate: String //일단여기 잠깐 string
    let wishes: Int
    let images: [Image]
    let content: String?
    let categoryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, content, categoryId
        case userID = "userId"
        case regdate, wishes, images
    }
}

extension Merchandise: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Merchandise, rhs: Merchandise) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Image
struct Image: Codable, Hashable {
    let merchandiseID, id, sequence: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case merchandiseID = "productId"
        case id, url, sequence
    }
}

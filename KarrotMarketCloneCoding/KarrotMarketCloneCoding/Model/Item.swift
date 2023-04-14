//
//  Item.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation
import UIKit

// MARK: - FetchedItemListData

struct FetchedItemListData: Codable {
    let content: FetchedItemList
    let pageable: Pageable?
    let size, number: Int
    let sort: Sort?
    let first, last: Bool
    let numberOfElements: Int
    let empty: Bool
    
    struct Pageable: Codable {
        let sort: Sort
        let offset, pageSize, pageNumber: Int
        let paged, unpaged: Bool
    }

    struct Sort: Codable {
        let empty, sorted, unsorted: Bool
    }
}

// MARK: - FetchedItemList

typealias FetchedItemList = [FetchedItem]

// MARK: - FetchedItem - HomeTable

struct FetchedItem: Codable {
    let imageURL: String?
    let id: Int
    let title: String
    let price: Int
    let createDateTime, townName, salesState: String
    let favoriteUserCount, chatCount: Int

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case id, title, price, createDateTime, townName, salesState, favoriteUserCount, chatCount
    }
}

extension FetchedItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FetchedItem, rhs: FetchedItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - FetchedItemDetail

struct FetchedItemDetail: Codable {
    let imageUrls: [String]
    
    // 사용자 정보
    let nickName: String
    let email: String
    let townName: String
    
    // 게시글 정보
    let title: String
    let content: String
    var category: Category?
    let price: Int
    let createDateTime: String
    let salesState: String
    let views, favoriteUserCount, chatCount: Int
    let preferPlace: LocationInfo
    let postsFromSeller: [FetchedItem]
    let negoAvailable: Bool
}


// MARK: - Item - New Post

struct Item: Codable {
    var title: String? = nil
    var content: String? = nil
    var category: Category?
    var price: Int = 0
    var preferPlace: LocationInfo?
    var negoAvailable: Bool = false
    var rangeStep: RangeOfSellingArea = .far
}

enum Category: String, CaseIterable, Codable {
    case DIGITAL, APPLIANCE, INTERIOR, HOME_KITCHEN, KID_PRODUCT, KID_BOOK, WOMEN_CLOTHES, WOMEN_ACCESSORY, MEN_FASHION, BEAUTY, SPORTS, HOBBY, CAR, BOOK, TICKET, FOOD, PET, PLANT, ETC
    
    var translatedKorean: String {
        switch self {
        case .DIGITAL:
            return "디지털기기"
        case .APPLIANCE:
            return "생활가전"
        case .INTERIOR:
            return "가구/인테리어"
        case .HOME_KITCHEN:
            return "생활/주방"
        case .KID_PRODUCT:
            return "유아제품"
        case .KID_BOOK:
            return "유아도서"
        case .WOMEN_CLOTHES:
            return "여성의류"
        case .WOMEN_ACCESSORY:
            return "여성잡화"
        case .MEN_FASHION:
            return "남성패션"
        case .BEAUTY:
            return "뷰티/미용"
        case .SPORTS:
            return "스포츠"
        case .HOBBY:
            return "취미"
        case .CAR:
            return "중고차"
        case .BOOK:
            return "도서"
        case .TICKET:
            return "티켓/교환권"
        case .FOOD:
            return "가공식품"
        case .PET:
            return "반려동물 용품"
        case .PLANT:
            return "식물"
        case .ETC:
            return "기타"
        }
    }
}

enum RangeOfSellingArea: String, Codable {
    case veryClose = "VERY_CLOSE"
    case close = "CLOSE"
    case middle = "MIDDLE"
    case far = "FAR"
}

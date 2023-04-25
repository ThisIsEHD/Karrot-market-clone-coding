//
//  Enum.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/22.
//

import Foundation

enum UserInfo {
    case indexPath
}

enum DeviceSize {
    case deviceHeight 
    case deviceWidth
}

enum Section: Int, CaseIterable {
    case main = 0
}

enum ItemList: String {
    
    case sales = "판매내역"
    case favorite = "관심목록"
    case purchase = "구매내역"
    
    var title: String {
        self.rawValue
    }
}

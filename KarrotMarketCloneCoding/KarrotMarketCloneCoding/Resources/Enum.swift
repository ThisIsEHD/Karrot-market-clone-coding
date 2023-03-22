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

enum ListTitle: String {
    case selling = "판매내역"
    case wish = "관심목록"
    case buy = "구매내역"
}

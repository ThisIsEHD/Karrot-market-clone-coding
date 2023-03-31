//
//  LocationInfo.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/31/23.
//

import Foundation

struct LocationInfo: Codable {
    var latitude: Int
    var longitude: Int
    var townName: String
    var alias: String
    
    init(latitude: Int, longitude: Int, townName: String, alias: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.townName = townName
        self.alias = alias
    }
}

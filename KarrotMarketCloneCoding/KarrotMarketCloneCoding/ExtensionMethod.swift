//
//  ExtensionMethod.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/08/02.
//

import Foundation

extension String {
    func getUserId() -> UserId? {
        let encodedUserId = self.components(separatedBy: ".")[1]
        guard let data = Data(base64Encoded: encodedUserId), let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any], let userId = jsonData["user_id"] as? String else { return nil }
        return userId
    }
}

extension Encodable {
    func toJSONData() -> Data? {
        let jsonData = try? JSONEncoder().encode(self)
        return jsonData
    }
}

extension Data {
    func toDictionary() -> [String: Any] {
        guard let dictionaryData = try? JSONSerialization.jsonObject(with: self) as? [String: Any] else { return [:] }
        return dictionaryData
    }
}

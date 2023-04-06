//
//  ExtensionMethod.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/08/02.
//

import Foundation
import UIKit

func jsonDecode<T: Codable>(type: T.Type, data: Data) -> T? {
    
    let jsonDecoder = JSONDecoder()
    let result: Codable?
    
    jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.myDateFormatter)
    
    do {
        result = try jsonDecoder.decode(type, from: data)
        
        return result as? T
    } catch {
        return nil
    }
}

extension Encodable {
    func toJSONData() -> Data? {
        
        let jsonData = try? JSONEncoder().encode(self)
        
        return jsonData
    }
}

extension Data {
    func toDictionary() -> [String: String] {
        
        guard let dictionaryData = try? JSONSerialization.jsonObject(with: self) as? [String: String] else { return [:] }
        
        return dictionaryData
    }
}

extension Date {
    
    func formatToString() -> String {
        let dateFormatter = DateFormatter()
        let Today = Calendar.current.component(.day, from: Date())
        dateFormatter.timeStyle = .short
        if Calendar.current.component(.day, from: self) == Today {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "YYYY.MM.dd"
        }
        return dateFormatter.string(from: self)
    }
}

extension CGFloat {
    
    static func getSize(of device: DeviceSize) -> CGFloat {
        switch device {
        case .deviceHeight:
            return UIScreen.main.bounds.height
        case .deviceWidth:
            return UIScreen.main.bounds.width
        }
    }
}

extension String {
    func checkOnlyNumbers() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9]$", options: .caseInsensitive)
            
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) { return true }
        } catch {
            print(error.localizedDescription)
            
            return false
        }
        return false
    }
}


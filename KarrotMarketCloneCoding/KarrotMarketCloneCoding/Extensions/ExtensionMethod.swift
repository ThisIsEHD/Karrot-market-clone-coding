//
//  ExtensionMethod.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/08/02.
//

import Foundation
import UIKit

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


extension UIImageView {
    func loadImage(url: String) {
        //  self.image = nil
        
        //   if let img = imgCache.object(forKey: url as NSString) {
        //   self.image = img
        //      return
        //    }
        if url == "" {
            self.image = UIImage(named: "logo")
        } else {
            
            Network.shared.fetchImage(url: url) { result in
                switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            //  imgCache.setObject(image, forKey: url as NSString)
                            self.image = image
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
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


//
//  Network.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/25.
//

import Foundation
import Alamofire

struct Network {
    
    static let shared = Network()
    
    func post(imageData: UIImage?) {
        
        let URL = ""
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : "토큰"]
        
        let userData = User(id: "a@gmail.com", nickName: "di", name: "foi", phone: "0239", profileImageUrl: nil)
        let jsonData = try? JSONEncoder().encode(userData)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(jsonData!, withName: "json", fileName: "json", mimeType: nil)
            
            if let image = imageData?.pngData() {
                multipartFormData.append(image, withName: "activityImage", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: URL, usingThreshold: UInt64(), headers: header).response { response in
            guard let statusCode = response.response?.statusCode,
                  statusCode == 200
            else { return }
        }
    }
}

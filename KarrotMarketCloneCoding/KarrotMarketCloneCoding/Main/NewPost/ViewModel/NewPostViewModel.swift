//
//  NewPostViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/31/23.
//

import UIKit
import Alamofire

struct NewPostViewModel {
    
    func registerItem(item: Item, images: [UIImage]) async -> Result<Bool,KarrotError> {
        
        guard let title = item.title,
              let content = item.content,
              let category = item.category else { return .failure(.unwrappingError)}
        
        let parameters: [String: String?] = ["title" : title,
                                             "content": content,
                                             "category": category.rawValue,
                                             "negoAvailable": "\(item.negoAvailable)",
                                             "price": "\(item.price)",
                                             "preferPlace.longitude": "\(item.preferPlace?.longitude ?? 0)",
                                             "preferPlace.latitude": "\(item.preferPlace?.latitude ?? 0)",
                                             "preferPlace.townName": item.preferPlace?.townName,
                                             "preferPlace.alias": item.preferPlace?.alias,
                                             "rangeStep": item.rangeStep.rawValue]
        
        let response = await AF.upload(multipartFormData: { data in
            
            for (key, value) in parameters {
                data.append(value?.data(using: .utf8) ?? Data(), withName: key)
            }
            
            if images.count != 0 {
                for image in images {
                    print(image.description)
                    data.append(image.jpegData(compressionQuality: 1) ?? Data(),
                                withName: "images",
                                fileName: "images.png",
                                mimeType: "image/png")
                }
            }
        }, with: KarrotRequest.registerItem).serializingDecodable(KarrotResponse<Int>.self).response
        
        let result = handleResponse(response)
        
        switch result {
        case .success:
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}

//
//  NewPostViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/31/23.
//

import UIKit
import Alamofire

struct NewPostViewModel {
    
    func registerItem(item: Item, images: [UIImage], completion: @escaping (Result<Data?,KarrotError>) -> ()) {
        guard let title = item.title,
              let content = item.content,
              let category = item.category
        else {
            return
        }
        
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
        AF.upload(multipartFormData: { data in
            
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
        }, with: KarrotRequest.registerItem).response { response in
            
            guard let httpResponse = response.response else { return }

            switch httpResponse.statusCode {
            case 200,201:
                completion(.success(.none))
            case 400:
                guard let message = response.data?.toDictionary() else {
                    completion(.failure(.decodingError))
                    return
                }
                print(message)
                completion(.failure(.badRequest))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 404:
                completion(.failure(.notFound))
            default:
                completion(.failure(.unknownError))
            }
        }
    }
}

//
//  ItemDetailViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import Foundation
import Alamofire

class ItemDetailViewModel {
    
    func fetchItem(userId: ID, productId: ProductID, completion: @escaping (Result<Item?, KarrotError>) -> Void) {
        
//        AF.request(KarrotRequest.fetchItem(userId,productId)).response { response in
//            
//            guard let httpResponse = response.response else { return }
//            
//            switch httpResponse.statusCode {
//            case 200:
//                guard let data = response.data, let list = jsonDecode(type: Item.self, data: data) else {
//                    completion(.failure(.decodingError))
//                    return
//                }
//                completion(.success(list))
//            default:
//                let message = response.data?.toDictionary()
//                completion(.failure(.unknownError))
//            }
//        }
    }
}

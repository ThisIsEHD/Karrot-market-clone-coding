//
//  MyPageViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import Foundation
import Alamofire

struct MyPageViewModel {
    
    func logout(completion: @escaping (Result<Bool?, KarrotError>) -> Void) {
        AF.request(KarrotRequest.logout).response { response in
            if let error = response.error {
                print(error)
            }
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
            case 200:
                completion(.success(true))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 404:
                completion(.failure(.notFound))
            default:
                guard let data = response.data, let error =  jsonDecode(type: KarrotResponseError.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                print(error)
                completion(.failure(.unknownError))
            }
        }
    }
}

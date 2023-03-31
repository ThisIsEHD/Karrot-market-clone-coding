//
//  AuthenticationViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import UIKit
import Alamofire

struct AuthenticationViewModel {
    
    func login(user: User, completion: @escaping (Result<Bool?, KarrotError>) -> Void) {
        AF.request(KarrotRequest.login(user)).response { response in
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
    
    func signup(user: User, profileImage: UIImage?, completion: @escaping (Result<Bool, KarrotError>) -> Void) {
        
        guard let imageData = (profileImage ?? UIImage(named: "user-selected"))?.jpegData(compressionQuality: 0.5) else { return }
        
        
        var parameters: [String: String?] = ["email": user.email,
                                             "password": user.password,
                                             "nickName": user.nickname]
        if user.userLocation != nil {
            parameters["town.alias"] = user.userLocation?.alias
            parameters["town.latitude"] = "\(user.userLocation?.latitude ?? 0)"
            parameters["town.longitude"] = "\(user.userLocation?.longitude ?? 0)"
            parameters["town.townName"] = user.userLocation?.townName
        }
        
        AF.upload(multipartFormData: { data in
            
            for (key, value) in parameters {
                data.append(value?.data(using: .utf8) ?? Data(), withName: key)
            }
            
            data.append(imageData,
                        withName: "image",
                        fileName: "image.png",
                        mimeType: "image/png")
            
        }, with: KarrotRequest.registerUser).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
            case 201:
                completion(.success(true))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 404:
                completion(.failure(.notFound))
            default:
                guard let data = response.data, let error = jsonDecode(type: KarrotResponseError.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                print(error)
                completion(.failure(.unknownError))
            }
        }
    }
}

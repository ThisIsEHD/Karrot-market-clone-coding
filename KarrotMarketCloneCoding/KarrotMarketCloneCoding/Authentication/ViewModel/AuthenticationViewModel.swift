//
//  AuthenticationViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import UIKit
import Alamofire

struct AuthenticationViewModel {
    
    func login(user: User) async -> Result<Bool, KarrotError> {
        
        let dataResponse = await AF.request(KarrotRequest.login(user)).serializingDecodable(KarrotResponse<Bool>.self).response
        let result = handleResponse(dataResponse)
        
        switch result {
        case .success:
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func signup(user: User, profileImage: UIImage?) async -> Result<Bool, KarrotError> {
        
        guard let imageData = (profileImage ?? UIImage(named: "user-selected"))?.jpegData(compressionQuality: 0.5) else {
            return .failure(.imageError)
        }
        
        var parameters: [String: String?] = ["email": user.email,
                                             "password": user.password,
                                             "nickName": user.nickname]
        if user.userLocation != nil {
            parameters["town.alias"] = user.userLocation?.alias
            parameters["town.latitude"] = "\(user.userLocation?.latitude ?? 0)"
            parameters["town.longitude"] = "\(user.userLocation?.longitude ?? 0)"
            parameters["town.townName"] = user.userLocation?.townName
        }
        
        let dataResponse = await AF.upload(multipartFormData: { data in
            
            for (key, value) in parameters {
                data.append(value?.data(using: .utf8) ?? Data(), withName: key)
            }
            
            data.append(imageData,
                        withName: "image",
                        fileName: "image.png",
                        mimeType: "image/png")
            
        }, with: KarrotRequest.registerUser).serializingDecodable(Bool.self).response
        let result = handleResponse(dataResponse)
        
        switch result {
        case .success:
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}

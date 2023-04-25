//
//  SettingViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import Foundation
import Alamofire

struct SettingViewModel {
    
    func logout() async -> Result<Bool, KarrotError> {
        
        let dataResponse = await AF.request(KarrotRequest.logout).serializingDecodable(KarrotResponse<Bool>.self).response
        let result = handleResponse(dataResponse)
        
        switch result {
        case .success:
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}

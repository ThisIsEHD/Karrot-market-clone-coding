//
//  FavoritesViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 4/21/23.
//

import Foundation
import Alamofire

class FavoritesViewModel {
    
    var fetchedItemCount: Int?
    var latestPage: Int?
    
    func fetchFavoriteItems() async -> Result<FetchedItemListData, KarrotError> {
      
        let dataResponse = await AF.request(KarrotRequest.fetchFavoriteItems).serializingDecodable(KarrotResponse<FetchedItemListData>.self).response
        let result = handleResponse(dataResponse)
        
        switch result {
        case .success(let response):
            
            guard let fetchedItemListData = response.data else {
                return .failure(.unwrappingError)
            }
            
            self.latestPage = fetchedItemListData.number
            self.fetchedItemCount = fetchedItemListData.numberOfElements
            
            return .success(fetchedItemListData)
        case .failure(let error):
            
            return .failure(error)
        }
    }
}

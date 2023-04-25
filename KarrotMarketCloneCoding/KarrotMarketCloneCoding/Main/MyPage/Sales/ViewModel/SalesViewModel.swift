//
//  SalesViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 4/21/23.
//

import Foundation
import Alamofire

enum SalesState: Codable {
    case DEFAULT, RESERVE, COMPLETE
}

class SalesViewModel {
    
    var fetchedItemCount: Int?
    var latestPage: Int?
    
    func fetchSalesItems(isHide: Bool? = nil, salesState: SalesState? = nil) async -> Result<FetchedItemListData, KarrotError> {
        
        var queryItems = [String : Any]()
        
        if let isHide = isHide {
            queryItems["isHide"] = isHide
        }
        
        if let salesState = salesState {
            queryItems["salesState"] = salesState
        }
        
        let dataResponse = await AF.request(KarrotRequest.fetchSellItems(queryItems)).serializingDecodable(KarrotResponse<FetchedItemListData>.self).response
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

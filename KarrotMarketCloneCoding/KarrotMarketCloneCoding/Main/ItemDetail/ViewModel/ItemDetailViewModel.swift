//
//  ItemDetailViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import Foundation
import Alamofire
import Combine

class ItemDetailViewModel {
    
    @Published var item: FetchedItemDetail?
    
    func fetchItem(productID: ProductID) async -> KarrotError? {
        
        let dataResponse = await AF.request(KarrotRequest.fetchItemDetail(productID)).serializingDecodable(KarrotResponse<FetchedItemDetail>.self).response
        
        let result = handleResponse(dataResponse)
        
        switch result {
        case .success(let response):
            guard let fetchedItemDetail = response.data else {
                return .unwrappingError
            }
            
            item = fetchedItemDetail
            
            return nil
        case .failure(let error):
            return error
        }
    }
}

//
//  HomeTableViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/26.
//

import Foundation
import Alamofire

class HomeTableViewModel {
    
    var fetchedItemCount: Int?
    var latestPage: Int?
    
    func fetchItems(title: String? = nil, category: Category? = nil, page: Int? = nil, size: Int? = nil) async -> Result<FetchedItemListData, KarrotError> {
        
        var queryItems = [String : Any]()
        
        if let title = title {
            queryItems["title"] = title
        }
        
        if let category = category {
            queryItems["category"] = category
        }
        
        if let page = page {
            queryItems["page"] = page
        }
        
        if let size = size {
            queryItems["size"] = size
        }
        
        let dataResponse = await AF.request(KarrotRequest.fetchItems(queryItems)).serializingDecodable(KarrotResponse<FetchedItemListData>.self).response
        // 에러 핸들링 싱글톤 객체 추가.
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

//
//  HomeTableViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/26.
//

import Foundation
import Alamofire

protocol HomeTableViewModelDelegate: AnyObject {
    func applySnapshot(snapshot: Snapshot)
}

class HomeTableViewModel {
    
    weak var delegate: HomeTableViewModelDelegate?
    
    var isViewBusy = false
    var fetchedItemCount: Int?
    var latestPage: Int?
    
    func fetchItems(title: String? = nil, category: Category? = nil, page: Int? = nil, size: Int? = nil, completion: (() -> Void)? = nil) async {
        guard !isViewBusy else { return }
        isViewBusy = true
        Task {
            
            let result = await fetchItems(title: title, category: category, page: latestPage, size: size)
            
            switch result {
            case .success(let fetchedItemListData):
                var snapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>()
                
                snapshot.appendSections([Section.main])
                snapshot.appendItems(fetchedItemListData.content)
                
                self.delegate?.applySnapshot(snapshot: snapshot)
                self.isViewBusy = false
                self.latestPage = fetchedItemListData.number
                self.fetchedItemCount = fetchedItemListData.numberOfElements
                
            case .failure(let error):
                print(error, #function)
            }
        }
    }
    
    private func fetchItems(title: String?, category: Category?, page: Int?, size: Int?) async -> Result<FetchedItemListData, KarrotError> {
        
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
        
        let response = await AF.request(KarrotRequest.fetchItems(queryItems)).serializingDecodable(ItemListResponse.self).response
        let result = handleResponse(response)
        switch result {
        case .success(let itemListResponse):
            let fetchedItemListData = itemListResponse.data
            return .success(fetchedItemListData)
        case .failure(let error):
            return .failure(error)
        }
    }
}

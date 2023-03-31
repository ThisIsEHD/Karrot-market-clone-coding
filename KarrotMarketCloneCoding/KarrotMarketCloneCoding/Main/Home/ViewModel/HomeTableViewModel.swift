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
    
    func fetchItems(title: String? = nil, category: Category? = nil, page: Int? = nil, size: Int? = nil, completion: (() -> Void)? = nil) {
        guard !isViewBusy else { return }
        isViewBusy = true
        
        fetchItems(title: title, category: category, page: latestPage, size: size) { result in
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
    
    private func fetchItems(title: String?, category: Category?, page: Int?, size: Int?, completion: @escaping (Result<FetchedItemListData, KarrotError>) -> ()) {
        
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
        
        AF.request(KarrotRequest.fetchItems(queryItems)).response { response in
            if response.error != nil {
                completion(.failure(.internalServerError))
                return
            }
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let responseBody = response.data,
                      let responseData = jsonDecode(type: ItemListResponse.self, data: responseBody) else {
                    completion(.failure(.decodingError))
                    return
                }
                let fetchedItemListData = responseData.data
                completion(.success(fetchedItemListData))
            case 400:
                completion(.failure(.badRequest))
            default:
                completion(.failure(.unknownError))
            }
        }
    }
}

//
//  HomeViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/26.
//

import UIKit
import Alamofire

class HomeViewModel {
    
    var dataSource: DataSource?
    var isViewBusy = true
    var lastItemID: Int?
    
    func loadData(lastID: Int?) {
        print("📕", lastItemID)
        guard isViewBusy == false else { return }
        
        isViewBusy = true
        
        Network.shared.fetchItems { [weak self] list in
            print(list)
            guard let weakSelf = self else { return }
            guard var snapshot = weakSelf.dataSource?.snapshot() else { return }
            print(list)
            DispatchQueue.global(qos: .background).async {
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
                if let items = list?.items {

                    if snapshot.numberOfSections == 0 {
                        snapshot.appendSections([.main])
                    }

                    snapshot.appendItems(item)
                    weakSelf.lastItemID = items.last?.id
                    weakSelf.isViewBusy = false

                    DispatchQueue.global(qos: .background).async {
                        weakSelf.dataSource?.apply(snapshot, animatingDifferences: false)
                    }
                }
            }
        }
        
//        Network.shared.httpGetJSON(url: Network.shared.getItemsListFetchingURL(last: lastID), in: FetchedItemsList.self) { [weak self] itemsList in
//            
//            guard let weakSelf = self else { return }
//            guard var snapshot = weakSelf.dataSource?.snapshot() else { return }
//            
//            DispatchQueue.global(qos: .background).async {
//                self?.dataSource?.apply(snapshot, animatingDifferences: false)
//                if let items = itemsList?.items {
//                    
//                    if snapshot.numberOfSections == 0 {
//                        snapshot.appendSections([.main])
//                    }
//                    
//                    snapshot.appendItems(items)
//                    weakSelf.lastProductID = items.last?.id
//                    weakSelf.isViewBusy = false
//                    
//                    DispatchQueue.global(qos: .background).async {
//                        weakSelf.dataSource?.apply(snapshot, animatingDifferences: false)
//                    }
//                }
//            }
//        }
    }
}

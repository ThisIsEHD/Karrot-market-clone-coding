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
    var isViewBusy = false
    var lastProductID: Int?
    
    func loadData(lastID: Int?) {
        
        guard isViewBusy == false else { return }
        
        isViewBusy = true
        
//        Network.shared.fetchItems { [weak self] list in
//            print(list)
//            guard let weakSelf = self else { return }
//            guard var snapshot = weakSelf.dataSource?.snapshot() else { return }
//            print(list)
//            DispatchQueue.global(qos: .background).async {
//                self?.dataSource?.apply(snapshot, animatingDifferences: false)
//                if let merchandises = list?.merchandises {
//
//                    if snapshot.numberOfSections == 0 {
//                        snapshot.appendSections([.main])
//                    }
//
//                    snapshot.appendItems(merchandises)
//                    weakSelf.lastProductID = merchandises.last?.id
//                    weakSelf.isViewBusy = false
//
//                    DispatchQueue.global(qos: .background).async {
//                        weakSelf.dataSource?.apply(snapshot, animatingDifferences: false)
//                    }
//                }
//            }
//        }
        
        Network.shared.httpGetJSON(url: Network.shared.getMerchandisesListFetchingURL(last: lastID), in: FetchedMerchandisesList.self) { [weak self] merchandisesList in
            
            guard let weakSelf = self else { return }
            guard var snapshot = weakSelf.dataSource?.snapshot() else { return }
            
            DispatchQueue.global(qos: .background).async {
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
                if let merchandises = merchandisesList?.merchandises {
                    
                    if snapshot.numberOfSections == 0 {
                        snapshot.appendSections([.main])
                    }
                    
                    snapshot.appendItems(merchandises)
                    weakSelf.lastProductID = merchandises.last?.id
                    weakSelf.isViewBusy = false
                    
                    DispatchQueue.global(qos: .background).async {
                        weakSelf.dataSource?.apply(snapshot, animatingDifferences: false)
                    }
                }
            }
        }
    }
}

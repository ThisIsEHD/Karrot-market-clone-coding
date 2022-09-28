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
        guard isViewBusy == false else { return }
        
        isViewBusy = true
        Network.shared.fetchItems(keyword: nil, category: nil, sort: nil, lastId: lastID) { [weak self] result in
            switch result {
            case .success(let list):
                guard let weakSelf = self else { return }
                guard var snapshot = weakSelf.dataSource?.snapshot() else { return }
                
                DispatchQueue.global(qos: .background).async {
                    self?.dataSource?.apply(snapshot, animatingDifferences: false)
                    if let items = list?.items {

                        if snapshot.numberOfSections == 0 {
                            snapshot.appendSections([.main])
                        }

                        snapshot.appendItems(items)
                        weakSelf.lastItemID = items.last?.id
                        weakSelf.isViewBusy = false

                        DispatchQueue.global(qos: .background).async {
                            weakSelf.dataSource?.apply(snapshot, animatingDifferences: false)
                        }
                    }
                }
            case .failure:
                print("서버에러")   //홈뷰컨에 얼럿 띄워야
            }
            
        }
    }
}

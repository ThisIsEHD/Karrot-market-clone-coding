//
//  HomeViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/26.
//

import Foundation
import UIKit
import Alamofire

class HomeViewModel {
    
    var dataSource: DataSource?
    var isViewBusy = true
    var lastProductID: Int?
    //    let cache = NSCache<NSURL, UIImage>()
    //    var cacheImage: UIImage?
    
    func loadData(lastID: Int?) {
        
        guard isViewBusy == false else { return }
        
        isViewBusy = true
        
        Network.shared.httpGetJSON(url: Network.shared.getMerchandisesListFetchingURL(last: lastID), in: FetchedMerchandisesList.self) { [weak self] merchandisesList in
            
            guard let weakSelf = self else { return }
            guard var snapshot = weakSelf.dataSource?.snapshot() else { return }
            
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
    /*
    func prefetchImage(at indexPath: IndexPath) {
        
        guard let merchandise = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let url = URL(string:merchandise.images.first?.url ?? "") else { return }
        
        AF.session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.cacheImage = UIImage(data: data)
        }
    }
    
    func loadImage(for merchandise: Merchandise) {
        if let cacheImage = cacheImage {
            print(#function)
            guard var snapshot = self.dataSource?.snapshot() else { return }
            guard snapshot.indexOfItem(merchandise) != nil else { return }
            snapshot.reloadItems([merchandise])
            DispatchQueue.global(qos: .background).async {
                self.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            return
        }
        guard let url = URL(string:merchandise.images.first?.url ?? "") else { return }
        
        AF.session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.cacheImage = UIImage(data: data)
        }
    }
     */
    
//    var merchandise: Merchandise
//
//    var name: String {
//        return merchandise.name
//    }
//
//    var price: Int {
//        return merchandise.price
//    }
//
//    var wishCount: Int? {
//        return merchandise.wishCount
//    }
//
//    var imageUrl: String? {
//        return merchandise.imageUrl
//    }
//
//    private var cachedImage: UIImage?
//
//    func configure(_ cell : MerchandiseTableViewCell) {
//        cell.nameLabel.text = name
//        cell.priceLabel.text = "\(price)원"
//    }
//
//
//    func downloadImage(completion: @escaping (UIImage?) -> Void) {
//        if let cachedImage = cachedImage {
//            completion(cachedImage)
//            return
//        }
//
//        guard let url = URL(string: "") else { return }
//        AF.session.dataTask(with: url) { [weak self] data, response, error in
//            guard let data = data else {
//                return
//            }
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                self?.cachedImage = image
//                completion(image)
//            }
//        }
//    }
//
//    init(merchandise: Merchandise) {
//        self.merchandise = merchandise
//    }
}

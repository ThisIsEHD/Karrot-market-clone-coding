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
    let cache = NSCache<NSURL, UIImage>()
    var cacheImage: UIImage?
    
    func loadData() {
        guard let url = URL(string: "") else { return }
        AF.session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard var snapshot = self?.dataSource?.snapshot() else { return }
            if snapshot.sectionIdentifiers.isEmpty {
                snapshot.appendSections([.main])
            }
            
            let newMerchandise = [
                Merchandise(ownerId: 1, id: 2, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil),
                Merchandise(ownerId: 2, id: 4, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil),
                Merchandise(ownerId: 3, id: 4, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil)
                ]
            snapshot.appendItems(newMerchandise)
            
            DispatchQueue.global(qos: .background).async {
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    
    func prefetchImage(at indexPath: IndexPath) {
        print(#function)
        guard let merchandise = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let url = URL(string:merchandise.imageUrl!) else { return }
        
        AF.session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.cacheImage = UIImage(data: data)
        }
    }
    
    func loadImage(for merchandise: Merchandise) {
        if let cacheImage = cacheImage {
            guard var snapshot = self.dataSource?.snapshot() else { return }
            guard snapshot.indexOfItem(merchandise) != nil else { return }
            snapshot.reloadItems([merchandise])
            DispatchQueue.global(qos: .background).async {
                self.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            return
        } 
        guard let url = URL(string:merchandise.imageUrl!) else { return }
        
        AF.session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.cacheImage = UIImage(data: data)
        }
    }
    
    
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

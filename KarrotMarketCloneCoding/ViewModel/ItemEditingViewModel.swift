//
//  ItemEditingViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/10/11.
//

import Foundation
import UIKit

class ItemEditingViewModel {
    
//    let newPostTableView = NewPostTableView(frame: .zero)
    
    var item = Item(id: nil, title: nil, content: nil, categoryId: nil, price: nil, regdate: nil, views: nil, wishes: nil, userId: nil, nickname: nil, profileImage: nil, thumbnail: nil, images: nil)
    var maxChoosableImages = 10
    var selectedImages: [UIImage] = [] {
        didSet {
            print("selectedImages changed, selectedImages = \(selectedImages)")
            maxChoosableImages = 10 - selectedImages.count
        }
    }
    // MARK: - First Cell
    func configureFirst(cell: PhotosSelectingTableViewCell) {
        cell.collectionView.viewModel = self
        cell.selectionStyle = .none
        cell.clipsToBounds = false
    }
    
    func numberOfItems() -> Int {
        selectedImages.count
    }
    
    func configureCollectionView(as cell: PhotosCollectionViewCell, at indexPath: IndexPath) {
        cell.photo.image = selectedImages[indexPath.item - 1]
        cell.indexPath = indexPath
        cell.clipsToBounds = false
    }
    
    func addImage(image: UIImage) {
        selectedImages.append(image)
    }
    
     func removeImage(in collectionView: UICollectionView,at indexPath: IndexPath) {
        print(selectedImages.count)
        selectedImages.remove(at: indexPath.item - 1)
        collectionView.reloadData()
    }
    
    // MARK: - Second Cell
     func configureSecond(cell: TitleTableViewCell) {
        
        cell.title.text = item.title
        cell.selectionStyle = .none
    }
    
     func secondCellDidEndEditing(text: String?) {
        item.title = text
    }
    
    // MARK: - Third Cell
    func configureThird(cell: BasicTableViewCell) {
        
        cell.textLabel?.text = item.categoryId == nil ? "카테고리 선택" : "\(Const.categories[item.categoryId! - 1])"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
    }
    
     func categoryDidTapped(cell: BasicTableViewCell ,indexPathRow: Int, in tableView: UITableView, at indexPath: [IndexPath]) {
        
        cell.textLabel?.text = "\(Const.categories[indexPathRow])"
        item.categoryId = indexPathRow + 1
        tableView.reloadRows(at: indexPath, with: .fade)
    }
    
    // MARK: - Fourth Cell
    func configureFourth(cell: PriceTableViewCell) {
        
        if let price = item.price {
            cell.priceTextField.text = "\(price)"
        }
        cell.selectionStyle = .none
    }
    
     func fourthCellDidEndEditing(price: Int?) {
        item.price = price
    }
    
    // MARK: - Fifth Cell
    
    func configureFifth(cell: DetailTableViewCell) {
        if let content = item.content {
            cell.content = content
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 999)
        cell.selectionStyle = .none
    }
    
     func fifthCellDidEndEditing(description: String?) {
        item.content = description
    }
    
    // MARK: - Add Images
     func addSelectedImages(image: UIImage) {
        selectedImages.append(image)
    }
}

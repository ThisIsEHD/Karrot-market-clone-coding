//
//  photosCollectionView.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/21.
//

import Foundation
import UIKit

final class photosCollectionView: UICollectionView {
    
    var viewModel: ItemEditingViewModel!
    
    var photoPickerCellTapped: (photosCollectionView) -> () = { sender in }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        print("😁")
        dataSource = self
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeImage), name: NotificationType.deleteButtonTapped.name, object: nil)
        
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func removeImage(_ notification: NSNotification) {
        
        if let indexPath = notification.userInfo?[UserInfo.indexPath] as? IndexPath {
            viewModel.removeImage(in: self, at: indexPath)
        }
    }
    
    private func registerCells() {
        
        let pickerCellNib = UINib(nibName: "PhotoPickerCollectionViewCell", bundle: nil)
        let photosCellNib = UINib(nibName: "PhotosCollectionViewCell", bundle: nil)
        
        register(pickerCellNib, forCellWithReuseIdentifier: "PhotoPickerCollectionViewCell")
        register(photosCellNib, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
    }
}

extension photosCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            if let cell = dequeueReusableCell(withReuseIdentifier: "PhotoPickerCollectionViewCell", for: indexPath) as? PhotoPickerCollectionViewCell {
                
                cell.selectedPhotosNumber = viewModel.numberOfItems()
                
                return cell
            }
        } else {
            if let cell = dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell {
                
                viewModel.configureCollectionView(as: cell, at: indexPath)
                
                return cell
            }
        }

        return UICollectionViewCell()
    }
}

extension photosCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            photoPickerCellTapped(self)
        }
    }
}

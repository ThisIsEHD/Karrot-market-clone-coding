//
//  photosCollectionView.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/21.
//

import Foundation
import UIKit

class photosCollectionView: UICollectionView {
    
    var images: [UIImage?] = [] {
        didSet {

            reloadData()
            print(#function)
        }
    }
    var photoPickerCellTapped: (photosCollectionView) -> () = { sender in }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            if let cell = dequeueReusableCell(withReuseIdentifier: "PhotoPickerCollectionViewCell", for: indexPath) as? PhotoPickerCollectionViewCell {
                
                cell.selectedPhotosNumber = images.count
                
                return cell
            }
        } else {
            if let cell = dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell {
                
                cell.photo.image = images[indexPath.item - 1]
                cell.indexPath = indexPath
                cell.clipsToBounds = false
                
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

//
//  PhotosSelectingTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit
import PhotosUI

final class PhotosSelectingTableViewCell: UITableViewCell {
    
    static let identifier = "PhotosSelectingTableViewCell"
    
    let collectionView: photosCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 60, height: 60)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        
        let cv = photosCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    static func nib() -> UINib {
        return UINib(nibName: "PhotosSelectingTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.layoutMarginsGuide.leadingAnchor, trailing: self.trailingAnchor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

//
//  PhotosCollectionViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/19.
//

import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {

    internal var indexPath = IndexPath(item: 0, section: 0)
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func delteButtonTapped(_ sender: Any) {
        
        NotificationCenter.default.post(name: NotificationType.deleteButtonTapped.name, object: nil, userInfo: [UserInfo.indexPath : indexPath])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo.layer.cornerRadius = 5
        photo.contentMode = .scaleAspectFill
        
        deleteButton.anchor(top: photo.topAnchor, topConstant: -16, trailing: photo.trailingAnchor, trailingConstant: -22)
    }
}

//
//  PhotosSelectingTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/17.
//

import UIKit

class PhotosSelectingTableViewCell: UITableViewCell {

    static let identifier = "PhotosSelectingTableViewCell"
    var selectedPhotosNumber = 0
    @IBOutlet weak var photoPicekrButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoPicekrButton.setTitle("\(selectedPhotosNumber)/10", for: .normal)
        photoPicekrButton.tintColor = .label
    }
    
    static func nib() -> UINib {
        
        return UINib(nibName: "PhotosSelectingTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

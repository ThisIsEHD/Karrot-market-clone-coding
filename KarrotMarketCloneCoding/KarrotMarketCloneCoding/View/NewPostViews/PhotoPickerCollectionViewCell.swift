//
//  PhotoPickerCollectionViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/20.
//

import UIKit

class PhotoPickerCollectionViewCell: UICollectionViewCell {

    var selectedPhotosNumber = 0
    
    @IBOutlet weak var selectedPhotosNumberLabel: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    
    static func nib() -> UINib {
        
        return UINib(nibName: "PhotoPickerCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        pickerButton.isUserInteractionEnabled = false
        sendSubviewToBack(pickerButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setPhotosNumberLabel()
        setPhotosNumberLabelLayout()
    }
    
    private func setPhotosNumberLabel() {
        
        selectedPhotosNumberLabel.text = "\(selectedPhotosNumber)"
        selectedPhotosNumberLabel.textColor = UIColor.appColor(.carrot)
    }
    
    private func setPhotosNumberLabelLayout() {
        
        selectedPhotosNumberLabel.anchor(bottom: pickerButton.bottomAnchor, bottomConstant: 9, leading: pickerButton.leadingAnchor, leadingConstant: 12)
        pickerButton.layer.borderWidth = 1
        pickerButton.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        pickerButton.layer.cornerRadius = 5
    }
}

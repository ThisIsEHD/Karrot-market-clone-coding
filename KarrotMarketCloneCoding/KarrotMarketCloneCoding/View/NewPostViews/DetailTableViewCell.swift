//
//  DetailTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/18.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {

    static let identifier = "DetailTableViewCell"
    
    private let textViewPlaceHolder = "게시글 내용을 작성해주세요. (가품 및 판매금지품목은 게시가 제한될 수 있어요.)"
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static func nib() -> UINib {
        return UINib(nibName: "DetailTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionTextView.font = .systemFont(ofSize: 18)
        descriptionTextView.text = textViewPlaceHolder
        descriptionTextView.textColor = .systemGray
        descriptionTextView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}


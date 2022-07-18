//
//  TitleTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/17.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    @IBOutlet var title: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        
        return UINib(nibName: "TitleTableViewCell", bundle: nil)
    }
    
    func setTitleTextField() {
        
        title.autocorrectionType = .no
        title.autocapitalizationType = .none
        title.borderStyle = .none
        title.leftViewMode = .always
        title.attributedPlaceholder = NSAttributedString(string: "₩ 가격 (선택사항)", attributes: [.foregroundColor : UIColor.systemGray])
    }
}

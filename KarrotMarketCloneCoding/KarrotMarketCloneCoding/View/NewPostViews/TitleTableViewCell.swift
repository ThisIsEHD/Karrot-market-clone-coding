//
//  TitleTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit

final class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    @IBOutlet var title: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.borderStyle = .none
        setTitleTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        
        return UINib(nibName: "TitleTableViewCell", bundle: nil)
    }
    
    private func setTitleTextField() {
        
        title.autocorrectionType = .no
        title.autocapitalizationType = .none
        title.borderStyle = .none
        title.leftViewMode = .always
        title.attributedPlaceholder = NSAttributedString(string: "제목", attributes: [.foregroundColor : UIColor.systemGray])
    }
}

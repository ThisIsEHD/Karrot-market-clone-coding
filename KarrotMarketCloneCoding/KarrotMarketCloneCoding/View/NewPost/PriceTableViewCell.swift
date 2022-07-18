//
//  PriceTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/17.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    static let identifier = "PriceTableViewCell"
    
    @IBOutlet weak var priceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPriceTextField()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PriceTableViewCell", bundle: nil)
    }
    
    func setPriceTextField() {
        
        priceTextField.autocorrectionType = .no
        priceTextField.autocapitalizationType = .none
        priceTextField.borderStyle = .none
        priceTextField.leftViewMode = .always
        priceTextField.attributedPlaceholder = NSAttributedString(string: "₩ 가격 (선택사항)", attributes: [.foregroundColor : UIColor.systemGray])
    }
}

extension PriceTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "₩ 가격 (선택사항)" {
//            textField.text.
        }
    }
}

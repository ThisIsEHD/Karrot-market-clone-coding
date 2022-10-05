//
//  PriceTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit

final class PriceTableViewCell: UITableViewCell {

    static let identifier = "PriceTableViewCell"
    internal var textChanged: ((String?) -> ()) = { _ in }
    
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceTextField.delegate = self
        wonLabel.textColor = .systemGray
        setPriceTextField()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PriceTableViewCell", bundle: nil)
    }
    
    private func setPriceTextField() {
        
        priceTextField.autocorrectionType = .no
        priceTextField.autocapitalizationType = .none
        priceTextField.borderStyle = .none
        priceTextField.leftViewMode = .always
        priceTextField.keyboardType = .numberPad
        priceTextField.attributedPlaceholder = NSAttributedString(string: "가격 (선택사항)", attributes: [.foregroundColor : UIColor.systemGray])
    }
}

extension PriceTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        wonLabel.textColor = .label
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text!.count < 11
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            wonLabel.textColor = .systemGray
        } else {
            textChanged(textField.text)
        }
    }
}

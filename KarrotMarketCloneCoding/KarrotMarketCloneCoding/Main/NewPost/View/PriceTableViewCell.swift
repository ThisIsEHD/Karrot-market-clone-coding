//
//  PriceTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit

final class PriceTableViewCell: UITableViewCell {

    static let identifier = "PriceTableViewCell"
    
    internal var textChanged: ((String?) -> Void) = { _ in }
    
    let wonLabel = UILabel()
    let priceTextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        priceTextField.delegate = self
        wonLabel.text = "₩"
        wonLabel.textColor = .systemGray
        setPriceTextField()
        
        contentView.addSubview(wonLabel)
        contentView.addSubview(priceTextField)
        
        wonLabel.anchor(top: contentView.topAnchor, topConstant: 10, bottom: contentView.bottomAnchor, bottomConstant: 10, leading: contentView.leadingAnchor, leadingConstant: 20, width: 20)
        priceTextField.anchor(top: contentView.topAnchor, topConstant: 15, bottom: contentView.bottomAnchor, bottomConstant: 15, leading: wonLabel.trailingAnchor, trailing: contentView.trailingAnchor, trailingConstant: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        if !string.checkOnlyNumbers() && isBackSpace != -92 {
            return false
        }
        
        // Limit the number of characters
        guard let text = textField.text else { return true }
        
        if string.isEmpty {
            return true
        }
        
        let newLength = text.count + string.count - range.length
        let maxLength = 11
        if newLength > maxLength {
            return false
        }
        
        // Check if the number is too large
        if range.location + range.length <= 10 {
            if let number = Int(text), number >= 1_000_000_000 {
                return false
            }
        }
        
        return true
        
//        let currentText = NSString(string: textField.text ?? "")
//        let finalText = currentText.replacingCharacters(in: range, with: string)
//
//        let utf8Char = string.cString(using: .utf8)
//        let isBackSpace = strcmp(utf8Char, "\\b")
//
//        if string.checkOnlyNumbers() || isBackSpace == -92 { return true }
//
//        return false
//
//        guard let text = textField.text else { return true }
//
//        let newLength = text.count + string.count - range.length
//        let maxLength = 11
//
//        if string.isEmpty {
//            return true
//        }
//
//        if range.location + range.length <= 10 {
//            if let number = Int(text), number >= 1_000_000_000 {
//                return false
//            } else {
//                return newLength <= maxLength
//            }
//        } else {
//            return false
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            wonLabel.textColor = .systemGray
        } else {
            textChanged(textField.text)
        }
    }
}

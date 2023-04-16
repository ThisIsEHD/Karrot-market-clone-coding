//
//  TitleTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit

final class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    internal var textChanged: (String?) -> Void = { _ in }
    
    private var titleTextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleTextField.delegate = self
        titleTextField.borderStyle = .none
        
        setTitleTextField()
        
        contentView.addSubview(titleTextField)
        
        titleTextField.anchor(top: contentView.topAnchor, topConstant: 15, bottom: contentView.bottomAnchor, bottomConstant: 15, leading: contentView.leadingAnchor, leadingConstant: 20, trailing: contentView.trailingAnchor, trailingConstant: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setTitleTextField() {
        
        titleTextField.autocorrectionType = .no
        titleTextField.autocapitalizationType = .none
        titleTextField.borderStyle = .none
        titleTextField.leftViewMode = .always
        titleTextField.attributedPlaceholder = NSAttributedString(string: "제목", attributes: [.foregroundColor : UIColor.systemGray])
    }
}

extension TitleTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text!.count < 201
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textChanged(textField.text)
    }
}

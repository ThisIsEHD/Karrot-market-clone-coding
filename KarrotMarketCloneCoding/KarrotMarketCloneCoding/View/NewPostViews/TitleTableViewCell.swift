//
//  TitleTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit

final class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    internal var textChanged: ((String)?) -> Void = { _ in }
    
    @IBOutlet var title: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.delegate = self
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

extension TitleTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text!.count < 201
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textChanged(textField.text)
    }
}

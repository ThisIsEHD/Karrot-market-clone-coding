//
//  UserInterfaceObjects.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        keyboardAppearance = .dark
        leftViewMode = .always
        leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 5, height: 5)))
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 10
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.systemGray])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

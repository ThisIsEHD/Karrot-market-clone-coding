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

class CustomNavigationBar: UINavigationBar {
    
    init(navigationBarTitle: String? = nil, leftBarButtonTitle: String? = nil,leftBarButtonImage: String? = nil, leftButtonColor: UIColor = .label, rightBarButtonTitle: String? = nil, rightBarButtonImage: String? = nil, rightButtonColor: UIColor = .label) {
        super.init(frame: .zero)
        
        let navigationItems = UINavigationItem(title: "")
        
        barTintColor = .systemBackground
        
        lazy var textLeftBarButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        lazy var imageLeftBarButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        
        lazy var textRightBarButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        lazy var imageRightBarButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        
        if let navigationBarTitle = navigationBarTitle {
            navigationItems.title = navigationBarTitle
        }
        
        if let leftBarButtonTitle = leftBarButtonTitle {
            textLeftBarButton.title = leftBarButtonTitle
            textLeftBarButton.tintColor = leftButtonColor
            
            navigationItems.leftBarButtonItem = textLeftBarButton
        }
        
        if let leftBarButtonImage = leftBarButtonImage {
            imageLeftBarButton.image = UIImage(systemName: "\(leftBarButtonImage)")
            imageLeftBarButton.tintColor = leftButtonColor
            
            navigationItems.leftBarButtonItem = imageLeftBarButton
        }
        
        if let rightBarButtonTitle = rightBarButtonTitle {
            textRightBarButton.title = rightBarButtonTitle
            textRightBarButton.tintColor = rightButtonColor
            
            navigationItems.rightBarButtonItem = textRightBarButton
        }
        
        if let rightBarButtonImage = rightBarButtonImage {
            imageRightBarButton.image = UIImage(systemName: "\(rightBarButtonImage)")
            textRightBarButton.tintColor = rightButtonColor
            
            navigationItems.rightBarButtonItem = imageRightBarButton
        }
        
        
        setItems([navigationItems], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

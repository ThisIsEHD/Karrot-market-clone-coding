//
//  CustomNavigationBar.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    init(navigationBarTitle: String? = nil, leftBarButtonTitle: String? = nil,leftBarButtonImage: String? = nil, leftButtonColor: UIColor = .label, rightBarButtonTitle: String? = nil, rightBarButtonImage: String? = nil, rightButtonColor: UIColor = .label, lefeButtonAction: Selector?, rightButtonAction: Selector?) {
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
            textLeftBarButton.action = lefeButtonAction
            
            navigationItems.leftBarButtonItem = textLeftBarButton
        }
        
        if let leftBarButtonImage = leftBarButtonImage {
            
            imageLeftBarButton.image = UIImage(systemName: "\(leftBarButtonImage)")
            imageLeftBarButton.tintColor = leftButtonColor
            imageLeftBarButton.action = lefeButtonAction
            
            navigationItems.leftBarButtonItem = imageLeftBarButton
        }
        
        if let rightBarButtonTitle = rightBarButtonTitle {
            
            textRightBarButton.title = rightBarButtonTitle
            textRightBarButton.tintColor = rightButtonColor
            textRightBarButton.action = rightButtonAction
            
            navigationItems.rightBarButtonItem = textRightBarButton
        }
        
        if let rightBarButtonImage = rightBarButtonImage {
            
            imageRightBarButton.image = UIImage(systemName: "\(rightBarButtonImage)")
            imageRightBarButton.tintColor = rightButtonColor
            imageRightBarButton.action = rightButtonAction
            
            navigationItems.rightBarButtonItem = imageRightBarButton
        }
        
        
        setItems([navigationItems], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

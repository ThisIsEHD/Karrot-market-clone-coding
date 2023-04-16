//
//  SimpleAlertController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/09/27.
//

import UIKit

class SimpleAlertController: UIAlertController {
    
    // MARK: - Initialize
    
    convenience init(message: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: completion)
        
        self.addAction(okAction)
    }
}



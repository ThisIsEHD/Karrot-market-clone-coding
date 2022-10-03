//
//  Alert.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/09/27.
//

import UIKit

class SimpleAlert: UIAlertController {
    // MARK: - Initialize
    convenience init(message: String?) {
        self.init(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        self.addAction(okAction)
    }
}



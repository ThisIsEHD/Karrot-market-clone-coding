//
//  Color.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation
import UIKit

enum AssetColor {
    case carrot
}

extension UIColor {
    
    static func appColor(_ name: AssetColor) -> UIColor {
        switch name {
        case .carrot:
            return UIColor(red: 255/255, green: 126/255, blue: 54/255, alpha: 1)
        }
    }
}

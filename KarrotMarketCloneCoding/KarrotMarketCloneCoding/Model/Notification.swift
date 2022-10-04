//
//  Notification.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/22.
//

import Foundation

enum NotificationType: String
{
    case deleteButtonTapped = "deleteButtonTapped"
    case logout = "logout"
    
    var name: Notification.Name
    {
        return Notification.Name(self.rawValue)
    }
}

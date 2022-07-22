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

    // Computed property which returns notification name
    var name: Notification.Name
    {
        return Notification.Name(self.rawValue)
    }
}

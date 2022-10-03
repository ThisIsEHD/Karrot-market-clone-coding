//
//  Authentication.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/10/04.
//

import Foundation

struct Authentication {
    
    static func goHomeAndLogout(go: @escaping () -> Void?) {
        if let id = UserDefaults.standard.object(forKey: Const.userId) as? String {
            KeyChain.delete(key: id)
            UserDefaults.standard.removeObject(forKey: Const.userId)
        }
        
        NotificationCenter.default.post(name: NotificationType.logout.name, object: nil)
        go()
    }
}

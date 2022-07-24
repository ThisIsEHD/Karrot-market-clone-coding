//
//  SceneDelegate.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let naviVC = UINavigationController(rootViewController: NewPostTableViewController())

        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }
}


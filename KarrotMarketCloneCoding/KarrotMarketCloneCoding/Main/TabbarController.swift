//
//  TabbarController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

final class TabbarController: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabbarController()
    }
}

// MARK: - Configure TabbarViewController

extension TabbarController {
    
    private func configureTabbarController() {
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.shadowImage = .none
        tabBar.barTintColor = .white
        tabBar.backgroundImage = UIImage()
        
        let homeViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "home-selected"), unselectedImage: #imageLiteral(resourceName: "home-unselected"), rootViewController: HomeTableViewController(), title: "홈")
        
//        let chatViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "chat-selected"), unselectedImage: #imageLiteral(resourceName: "chat-unselected"), rootViewController: ChatTableViewController(), title: "채팅")
        
        let profileViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "user-selected"), unselectedImage: #imageLiteral(resourceName: "user-unselected"), rootViewController: MyPageViewController(), title: "나의당근")
        
        viewControllers = [homeViewController/*, chatViewController*/, profileViewController]
    }
    
    private func templateNavigationController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.shadowImage = .none
        nav.navigationBar.backgroundColor = .white
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = .black
        
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
//        nav.tabBarController?.tabBar.barTintColor = .white
        nav.title = title
        nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        return nav
    }
}

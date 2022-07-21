//
//  TabbarController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

class TabbarController: UITabBarController {
    // MARK: - Properties

    // MARK: - Actions
   
    func checkIfUserIsLoggedIn() {
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureViewController()
    }
    
    // MARK: - Configure UI
    
    func configureViewController() {
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemBackground
        
        let homeViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "home-selected"), unselectedImage: #imageLiteral(resourceName: "home-unselected"), rootViewController: MainViewController(), title: "홈")
        
        let chatViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "chat-selected"), unselectedImage: #imageLiteral(resourceName: "chat-unselected"), rootViewController: ChatViewController(), title: "채팅")
        
        let profileViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "user-selected"), unselectedImage: #imageLiteral(resourceName: "user-unselected"), rootViewController: MyKarrotTableViewController(), title: "나의당근")
        
        viewControllers = [homeViewController, chatViewController, profileViewController]
    }
    
    func templateNavigationController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
//        nav.tabBarController?.tabBar.layer.borderWidth = 1
        nav.navigationBar.tintColor = .black
        nav.title = title
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        return nav
    }
}

// MARK: - AuthenticationDelegate

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

extension TabbarController: AuthenticationDelegate {
    
    func authenticationDidComplete() {
        /// 델리게이트를 설정해서 특정부분에서 이 메소드가 항상 호출되므로 user의 정보를 fetch할 수 있다.
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - UploadPostControllerDelegate

protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadPost()
}

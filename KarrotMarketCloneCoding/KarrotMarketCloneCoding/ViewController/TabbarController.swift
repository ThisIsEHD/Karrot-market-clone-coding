//
//  TabbarController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit
import AVFoundation

final class TabbarController: UITabBarController {
    // MARK: - Properties
    var user: User? {
        didSet {
            configureTabbarController()
        }
    }

    // MARK: - Actions
   
    func presentUserCheckVC() {
        DispatchQueue.main.async { [weak self] in
            let userCheckVC = UserCheckViewController()
            
            let nav = UINavigationController(rootViewController: userCheckVC)
            nav.modalPresentationStyle = .fullScreen
            
            self?.present(nav, animated: false, completion: nil)
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        let userId = UserDefaults.standard.object(forKey: Const.userId.asItIs) as? String ?? ""
        let token = KeyChain.read(key: userId)
        
        if token == nil {
            presentUserCheckVC()
        } else {
            Network.shared.fetchUser(id: userId) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    
                    switch error {
                    case .serverError:
                        let alert = SimpleAlert(message: "서버에러. 나중에 다시 시도해주세요.")
                        DispatchQueue.main.async { self.present(alert, animated: true) }
                    default:
                        print(error)
                        self.presentUserCheckVC()
                    }
                }
            }
        }
    }
    
    // MARK: - Life Cycle    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - Configure TabbarViewController
    
    private func configureTabbarController() {
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemBackground
        
        let homeViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "home-selected"), unselectedImage: #imageLiteral(resourceName: "home-unselected"), rootViewController: HomeViewController(), title: "홈")
        
        let chatViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "chat-selected"), unselectedImage: #imageLiteral(resourceName: "chat-unselected"), rootViewController: ChatViewController(), title: "채팅")
        
        let profileViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "user-selected"), unselectedImage: #imageLiteral(resourceName: "user-unselected"), rootViewController: MyKarrotTableViewController(user: user), title: "나의당근")
        
        viewControllers = [homeViewController, chatViewController, profileViewController]
    }
    
    private func templateNavigationController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.navigationBar.barTintColor = .systemBackground
        nav.navigationBar.backgroundColor = .systemBackground
        nav.navigationBar.isTranslucent = true
        nav.title = title
        nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return nav
    }
}

//
//  TabbarController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

final class TabbarController: UITabBarController {
    // MARK: - Properties
    var user: User? {
        willSet {
            configureTabbarController()
        }
    }
    var token: String?

    // MARK: - Actions
   
    func presentUserCheckVC() {
        DispatchQueue.main.async { [weak self] in
            let userCheckVC = UserCheckViewController()
            userCheckVC.authenticationDelegate = self
            
            let nav = UINavigationController(rootViewController: userCheckVC)
            nav.modalPresentationStyle = .fullScreen
            
            self?.present(nav, animated: false, completion: nil)
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        token = UserDefaults.standard.string(forKey: "AccessToken")
        
        guard let token = token else {
            presentUserCheckVC()
            return
        }
        presentUserCheckVC()
//        fetchUser(token: token)
    }
    
    private func fetchUser(token: Token) {
        let userIdBase64 = token.components(separatedBy: ".")[1]
        guard let data = Data(base64Encoded: userIdBase64) else { print("data is nil"); return }
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
            guard let userId = json["user_id"] as? String else { print("user_id is nil"); return }
            Network.shared.fetch(user: userId, token: token) { [self] user in
                guard let user = user else { return }
                self.user = user
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    }
//    deinit {
//        UserDefaults.standard.removeObject(forKey: "AccessToken")
//    }
    
    
    // MARK: - Configure TabbarViewController
    
    private func configureTabbarController() {
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemBackground
        
        let homeViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "home-selected"), unselectedImage: #imageLiteral(resourceName: "home-unselected"), rootViewController: HomeViewController(), title: "홈")
        
        let chatViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "chat-selected"), unselectedImage: #imageLiteral(resourceName: "chat-unselected"), rootViewController: ChatViewController(), title: "채팅")
        
        let profileViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "user-selected"), unselectedImage: #imageLiteral(resourceName: "user-unselected"), rootViewController: MyKarrotTableViewController(), title: "나의당근")
        
        viewControllers = [homeViewController, chatViewController, profileViewController]
    }
    
    private func templateNavigationController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.title = title
        nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return nav
    }
}

// MARK: - AuthenticationDelegate

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete(token: Token)
}

extension TabbarController: AuthenticationDelegate {
    
    func authenticationDidComplete(token: Token) {
        self.dismiss(animated: false, completion: nil)
        self.token = token
        UserDefaults.standard.set(token, forKey: "AccessToken")
        fetchUser(token: token)
    }
}


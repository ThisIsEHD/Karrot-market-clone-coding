//
//  SceneController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/21/23.
//

import UIKit

final class SceneController {
    
    static let shared = SceneController()
    
    private init() {
        registerLoginStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
            UIView.transition(with: window,
                              duration: 0.8,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
    
    func show(in window: UIWindow?) {
        self.window = window
        
        guard let window = window else  { return }
        
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        
        checkLoggedIn()
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: Constant.isLoggedIn)
        NotificationCenter.default.post(name: .loginStateChanged, object: nil)
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: Constant.isLoggedIn)
        NotificationCenter.default.post(name: .loginStateChanged, object: nil)
    }
    
    private func registerLoginStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoggedIn),
                                               name: .loginStateChanged,
                                               object: nil)
    }
        
    @objc private func checkLoggedIn() {
        
        if UserDefaults.standard.bool(forKey: Constant.isLoggedIn) {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        rootViewController = TabbarController()
    }

    private func routeToLogin() {
        rootViewController = UINavigationController(rootViewController: UserCheckViewController())
    }
}


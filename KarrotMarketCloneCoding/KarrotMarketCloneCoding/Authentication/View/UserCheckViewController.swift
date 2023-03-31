//
//  UserCheckViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation
import UIKit

final class UserCheckViewController: UIViewController {
    
    let userCheckView = UserCheckView(frame: .zero)
        
    override func loadView() {
        view = userCheckView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCheckView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        userCheckView.setupLoginGestureRecognizer(target: self, selector: #selector(logIn))
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc func signUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func logIn() {
        let signInVC = SignInViewController()
        navigationController?.pushViewController(signInVC, animated: true)
    }
}

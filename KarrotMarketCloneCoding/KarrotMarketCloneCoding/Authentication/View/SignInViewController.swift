//
//  SignInViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

final class SignInViewController: SignUpViewController {
    
    let signInViewModel = AuthenticationViewModel()
    
    override func configureNextScene() {
        
        guard let email = RealView.emailTextField.text else { return }
        guard let password = RealView.passwordTextField.text else { return }
        
        signInViewModel.login(user: User(email: email, password: password)) { result in
            switch result {
            case .success:
                SceneController.shared.login()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealView.helloLabel.text = "안녕하세요!,\n이메일로 로그인해주세요."
        RealView.signButton.setTitle("로그인", for: .normal)
    }
}

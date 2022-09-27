//
//  SignInViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

final class SignInViewController: SignUpViewController {
    
    override func configureNextScene() {
        guard let email = RealView.emailTextField.text else { return }
        guard let password = RealView.passwordTextField.text else { return }
        
        Network.shared.auth(email: email, pw: password) { alert in
            DispatchQueue.main.async {
                if let alert = alert {
                    self.present(alert, animated: true)
                } else {
                    print("dismiss")
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealView.helloLabel.text = "안녕하세요!,\n이메일로 로그인해주세요."
        RealView.signButton.setTitle("로그인", for: .normal)
    }
}

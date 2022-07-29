//
//  SignInViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

final class SignInViewController: UIViewController {
    
    let signInView = ReusableSignView(frame: .zero)
    
    weak var authenticationDelegate: AuthenticationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = signInView
        
        signInView.emailTextField.delegate = self
        signInView.passwordTextField.delegate = self
        
        signInView.helloLabel.text = "안녕하세요!,\n이메일로 로그인해주세요."
        signInView.signButton.setTitle("로그인", for: .normal)
        
        signInView.signButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    @objc func signIn() {
        guard let email = signInView.emailTextField.text else { return }
        guard let password = signInView.passwordTextField.text else { return }
        Network.shared.auth(email: email, pw: password) { token in
            self.authenticationDelegate?.authenticationDidComplete(token: token)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signInView.emailTextField {
            signInView.passwordTextField.becomeFirstResponder()
        } else {
            signIn()
        }
        return true
    }
}

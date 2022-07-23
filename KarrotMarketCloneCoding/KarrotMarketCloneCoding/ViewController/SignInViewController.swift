//
//  SignInViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

class SignInViewController: UIViewController {
    
    let signInView = ReusableSignView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = signInView
        
        signInView.emailTextField.delegate = self
        signInView.passwordTextField.delegate = self
        
        signInView.helloLabel.text = "안녕하세요!,\n이메일로 로그인해주세요."
        signInView.signUpButton.setTitle("로그인", for: .normal)
        
        signInView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    @objc func signUp() {
        print("signup")
    }
}

extension SignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == signInView.emailTextField {
          signInView.passwordTextField.becomeFirstResponder()
    } else {
        signUp()
    }
    return true
  }
}

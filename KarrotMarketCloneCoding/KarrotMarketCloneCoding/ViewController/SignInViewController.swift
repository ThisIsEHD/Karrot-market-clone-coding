//
//  SignInViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

class SignInViewController: UIViewController {
    
    let realView = ReusableSignView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = realView
        
        realView.emailTextField.delegate = self
        realView.passwordTextField.delegate = self
        
        realView.helloLabel.text = "안녕하세요!,\n이메일로 로그인해주세요."
        realView.signUpButton.setTitle("로그인", for: .normal)
        
        realView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    @objc func signUp() {
        print("signup")
    }
}

extension SignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == realView.emailTextField {
          realView.passwordTextField.becomeFirstResponder()
    } else {
        signUp()
    }
    return true
  }
}

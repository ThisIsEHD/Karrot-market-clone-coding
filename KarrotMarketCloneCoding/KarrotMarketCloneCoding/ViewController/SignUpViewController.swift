//
//  SignUpViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/14.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    let realView = ReusableSignView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = realView
        
        realView.emailTextField.delegate = self
        realView.passwordTextField.delegate = self
        
        realView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    @objc func signUp() {
        navigationController?.pushViewController(ProfileEditingViewController(), animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == realView.emailTextField {
          realView.passwordTextField.becomeFirstResponder()
    } else {
        signUp()
    }
    return true
  }
}

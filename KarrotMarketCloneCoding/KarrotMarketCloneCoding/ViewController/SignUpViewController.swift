//
//  SignUpViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    let signUpView = ReusableSignView(frame: .zero)
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.emailTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        
        signUpView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        setupNaviBar()
    }
    
    @objc func signUp() {
        navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    private func setupNaviBar() {

        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.left"), transitionMaskImage: nil)
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backBarButtonItem?.title = "dk"
    }
}

extension SignUpViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == signUpView.emailTextField {
          signUpView.passwordTextField.becomeFirstResponder()
    } else {
        signUp()
    }
    return true
  }
}

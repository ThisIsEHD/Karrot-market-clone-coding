//
//  SignUpViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import Foundation
import UIKit

final class SignUpViewController: UIViewController {
    
    let signUpView = ReusableSignView(frame: .zero)
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.emailTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        
        signUpView.signButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        setupNaviBar()
    }
    
    @objc func signUp() {
        guard let email = signUpView.emailTextField.text else { return }
        guard let password = signUpView.passwordTextField.text else { return }
//        Network.shared.register(user: user)
        navigationController?.popViewController(animated: true)
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

//
//  SignUpViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import Foundation
import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    internal let RealView = ReusableSignView(frame: .zero)
    private var emailValidationOkay = false
    private var passwordValidationOkay = false
    
    override func loadView() {
        view = RealView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealView.emailTextField.delegate = self
        RealView.passwordTextField.delegate = self
        
        RealView.signButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        setupNaviBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc private func doneButtonTapped() {
        validateCheck(RealView.emailTextField)
        validateCheck(RealView.passwordTextField)
        checkDoneButtonPossible()
        
        guard emailValidationOkay && passwordValidationOkay else { return }
        
        configureNextScene()
    }
    
    internal func configureNextScene() {
        guard let email = RealView.emailTextField.text else { return }
        guard let password = RealView.passwordTextField.text else { return }
        
        let nextVC = ProfileSettingViewController()
        
        nextVC.email = email
        nextVC.pw = password
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func validateCheck(_ textField: UITextField) {
        switch textField {
        case RealView.emailTextField:
            
            guard let email = textField.text else { return }
            let range = email.range(of: "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", options: .regularExpression)
            
            emailValidationOkay = range != nil ? true : false
            
        case RealView.passwordTextField:
            
            guard let password = textField.text else { return }
            let range = password.range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{7,}", options: .regularExpression)
            
            passwordValidationOkay = range != nil ? true : false
        default: break
        }
    }
    
    private func checkDoneButtonPossible() {
        RealView.signButton.backgroundColor = emailValidationOkay && passwordValidationOkay ? UIColor.appColor(.carrot) : .systemGray
        RealView.signButton.isEnabled = emailValidationOkay && passwordValidationOkay ? true : false
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
        if textField == RealView.emailTextField {
            RealView.passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case RealView.emailTextField:
            validateCheck(textField)
            checkDoneButtonPossible()
        case RealView.passwordTextField:
            validateCheck(textField)
            checkDoneButtonPossible()
        default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        validateCheck(textField)
        checkDoneButtonPossible()
        return true
    }
}

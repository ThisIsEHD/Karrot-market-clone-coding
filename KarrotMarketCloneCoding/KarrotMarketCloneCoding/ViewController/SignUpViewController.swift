//
//  SignUpViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/14.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!,\n이메일로 회원가입해주세요."
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeholder: "이메일")
        
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: "비밀번호")
        
        return textField
    }()
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.appColor(.carrot)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signUpButton])
        
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(helloLabel)
        setHelloLabelLayout()
        
        view.addSubview(stackView)
        setStackViewLayout()        
    }
    
    private func setHelloLabelLayout() {
        helloLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 30, leading: view.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 10)
    }
    
    private func setStackViewLayout() {
        stackView.anchor(top: helloLabel.bottomAnchor, topConstant: 25, leading: view.leadingAnchor, leadingConstant: 10, trailing: view.trailingAnchor, trailingConstant: 10)
    }
    
    @objc func signUp() {
        print("signup")
    }
}

extension SignUpViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
        passwordTextField.becomeFirstResponder()
    } else {
        signUp()
    }
    return true
  }
}

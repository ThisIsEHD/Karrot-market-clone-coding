//
//  ReusableSignView.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/14.
//

import UIKit

class ReusableSignView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        self.addSubview(helloLabel)
        setHelloLabelLayout()
        
        self.addSubview(stackView)
        setStackViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!,\n이메일로 회원가입해주세요."
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        
        return label
    }()
    internal let emailTextField: UITextField = {
        let textField = CustomTextField(placeholder: "이메일")
        
        return textField
    }()
    internal let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: "비밀번호")
        
        return textField
    }()
    internal let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.appColor(.carrot)
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signUpButton])
        
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private func setHelloLabelLayout() {
        helloLabel.anchor(top: self.safeAreaLayoutGuide.topAnchor, topConstant: 30, leading: self.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 10)
    }
    
    private func setStackViewLayout() {
        stackView.anchor(top: helloLabel.bottomAnchor, topConstant: 25, leading: self.leadingAnchor, leadingConstant: 10, trailing: self.trailingAnchor, trailingConstant: 10)
    }
    
//    @objc func signUp() {
//        print("signup")
//    }
}
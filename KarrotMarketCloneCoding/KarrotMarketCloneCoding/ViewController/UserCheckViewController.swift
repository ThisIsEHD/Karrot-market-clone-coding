//
//  UserCheckViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation
import UIKit

final class UserCheckViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let appDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "당신 근처의 당근마켓"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    private let appDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "중고 거래부터 동네 정보까지,\n지금 내 동네를 선택하고 시작해보세요!"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.appColor(.carrot)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        return button
    }()
    private let userCheckingLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 계정이 있나요?"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        
        return label
    }()
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.appColor(.carrot)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userCheckingLabel, loginLabel])
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground    //이걸 안해주면 검은 화면이 나옴 왜그러지
        
        view.addSubview(logoImageView)
        setLogoImageViewLayout()
        
        view.addSubview(appDescriptionLabel)
        setAppDescriptionLabelLayout()
        
        view.addSubview(appDetailLabel)
        setAppDetailLabelLayout()
        
        view.addSubview(signUpButton)
        setSignUpButtonLayout()
        
        view.addSubview(stackView)
        setStackViewLayout()
        
        setupGestureRecognizer()
    }

    private func setLogoImageViewLayout() {
        logoImageView.anchor(top: view.topAnchor,
                             topConstant: CGFloat.getSize(of: .deviceHeight) / 5,
                             leading: view.leadingAnchor,
                             leadingConstant: (CGFloat.getSize(of: .deviceWidth) - 200) / 2,
                             trailing: view.trailingAnchor,
                             trailingConstant: (CGFloat.getSize(of: .deviceWidth) - 200) / 2,
                             width: 200, height: 200)
    }
    
    private func setAppDescriptionLabelLayout() {
        appDescriptionLabel.centerX(inView: view,
                                    topAnchor: logoImageView.bottomAnchor,
                                    topConstant: 5)
    }
    
    private func setAppDetailLabelLayout() {
        appDetailLabel.centerX(inView: view,
                               topAnchor: appDescriptionLabel.bottomAnchor,
                               topConstant: 10)
    }
    
    private func setSignUpButtonLayout() {
        signUpButton.anchor(top: appDetailLabel.bottomAnchor,
                            topConstant: CGFloat.getSize(of: .deviceHeight) / 4,
                            leading: view.leadingAnchor,
                            leadingConstant: 5,
                            trailing: view.trailingAnchor,
                            trailingConstant: 10,
                            height: 50)
    }
    
    private func setStackViewLayout() {
        stackView.centerX(inView: view,
                          topAnchor: signUpButton.bottomAnchor,
                          topConstant: 15)
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logIn))
        loginLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func signUp() {
        
    }
    
    @objc func logIn() {
        print("hey")
    }
}

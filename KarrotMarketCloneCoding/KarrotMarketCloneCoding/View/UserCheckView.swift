//
//  UserCheckView.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/23.
//

import UIKit

final class UserCheckView: UIView {

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
    
    internal lazy var signUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.appColor(.carrot)
        button.layer.cornerRadius = 10
        
        return button
    }()
    private let userCheckingLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "이미 계정이 있나요?"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        
        return label
    }()
    internal let loginLabel: UILabel = {
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(logoImageView)
        addSubview(appDescriptionLabel)
        addSubview(appDetailLabel)
        addSubview(signUpButton)
        addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setLogoImageViewLayout()
        setAppDescriptionLabelLayout()
        setAppDetailLabelLayout()
        setSignUpButtonLayout()
        setStackViewLayout()
    }
    
    private func setLogoImageViewLayout() {
        
        logoImageView.anchor(top: topAnchor,
                             topConstant: CGFloat.getSize(of: .deviceHeight) / 5,
                             leading: leadingAnchor,
                             leadingConstant: (CGFloat.getSize(of: .deviceWidth) - 200) / 2,
                             trailing: trailingAnchor,
                             trailingConstant: (CGFloat.getSize(of: .deviceWidth) - 200) / 2,
                             width: 200, height: 200)
    }
    
    private func setAppDescriptionLabelLayout() {
        
        appDescriptionLabel.centerX(inView: self,
                                    topAnchor: logoImageView.bottomAnchor,
                                    topConstant: 5)
    }
    
    private func setAppDetailLabelLayout() {
        
        appDetailLabel.centerX(inView: self,
                               topAnchor: appDescriptionLabel.bottomAnchor,
                               topConstant: 10)
    }
    
    private func setSignUpButtonLayout() {
        
        signUpButton.anchor(top: appDetailLabel.bottomAnchor,
                            topConstant: CGFloat.getSize(of: .deviceHeight) / 5,
                            leading: leadingAnchor,
                            leadingConstant: 5,
                            trailing: trailingAnchor,
                            trailingConstant: 10,
                            height: 50)
    }
    
    private func setStackViewLayout() {
        
        stackView.centerX(inView: self,
                          topAnchor: signUpButton.bottomAnchor,
                          topConstant: 15)
    }
    
    internal func setupLoginGestureRecognizer(target: UIViewController, selector: Selector) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: selector)
        
        loginLabel.addGestureRecognizer(tapGestureRecognizer)
    }
}

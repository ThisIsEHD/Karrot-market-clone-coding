//
//  ReusableProfileView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import Foundation
import UIKit

class ReusableProfileView: UIView {

    // MARK: - Properties
    
    private let profileImageView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "defaultProfileImage"))
        
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.1
        
        return iv
    }()
    private let nicknameLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        
        return lbl
    }()
    
    // MARK: - Actions
    
    func configure(image: UIImage?) {
        if let image = image {
            profileImageView.image = image
        }
    }
    
    func configure(nickname: String?) {
        nicknameLabel.text = nickname
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confifureViews()
        setNicknameLabelConstraints()
    }
    
    convenience init(imageSize: CGFloat) {
        self.init()
        
        setProfileImageViewConstraints(size: imageSize)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configure Views
    
    private func confifureViews() {
        
        self.addSubview(profileImageView)
        self.addSubview(nicknameLabel)
    }
    
    // MARK: - Setting Constraints
    
    private func setProfileImageViewConstraints(size: CGFloat) {
        
        profileImageView.anchor(leading: self.leadingAnchor,
                                leadingConstant: 15,
                                width: size - 10, height: size - 10)
        profileImageView.centerY(inView: self)
        profileImageView.layer.cornerRadius = (size - 10) / 2
    }
    
    private func setNicknameLabelConstraints() {
        
        nicknameLabel.centerY(inView: profileImageView)
        nicknameLabel.anchor(leading: profileImageView.trailingAnchor,
                             leadingConstant: 15)
    }
}

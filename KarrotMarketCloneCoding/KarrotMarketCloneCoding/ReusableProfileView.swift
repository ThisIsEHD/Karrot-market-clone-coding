//
//  ReusableProfileView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import Foundation
import UIKit

class ReusableProfileView: UIView {
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "defaultProfileImage"))
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.1
        return iv
    }()
    
    private let nickNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "욘듀"
        lbl.font = UIFont.boldSystemFont(ofSize: 19)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
        
        setProfileImageViewConstraints(size: frame.height)
        setNickNameLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
// MARK: - configureUI
extension ReusableProfileView {
    
    func setProfileImageViewConstraints(size: CGFloat) {
        profileImageView.anchor(leading: self.safeAreaLayoutGuide.leadingAnchor,
                                leadingConstant: 15,
                                width: size - 30, height: size - 30)
        profileImageView.centerY(inView: self)
        profileImageView.layer.cornerRadius = (size - 30) / 2
    }
    
    func setNickNameLabelConstraints() {
        nickNameLabel.centerY(inView: profileImageView)
        nickNameLabel.anchor(leading: profileImageView.trailingAnchor,
                             leadingConstant: 15)
    }
}

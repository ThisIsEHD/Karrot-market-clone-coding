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
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
        setNickNameLabelConstraints()
    }
    
    convenience init(imageSize: CGFloat) {
        self.init()
        setProfileImageViewConstraints(size: imageSize)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
// MARK: - configureUI
extension ReusableProfileView {
    
    private func setProfileImageViewConstraints(size: CGFloat) {
        profileImageView.anchor(leading: self.leadingAnchor,
                                leadingConstant: 15,
                                width: size - 10, height: size - 10)
        profileImageView.centerY(inView: self)
        profileImageView.layer.cornerRadius = (size - 10) / 2
    }
    
    private func setNickNameLabelConstraints() {
        nickNameLabel.centerY(inView: profileImageView)
        nickNameLabel.anchor(leading: profileImageView.trailingAnchor,
                             leadingConstant: 15)
    }
}

//
//  ChatTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    
    ///프로필이미지
    let profileImageView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "defaultProfileImage"))
        
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.1
        
        return iv
    }()
    
    ///닉네임, 주소, 시간
    var nicknameLabel = UILabel()
    ///가장 최근 채팅문자
    var latestMessageLabel = UILabel()
    ///상품 썸네일이미지
    var itemThumbnailImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        setupProfileImageView()
        setupNicknameLabel()
        setupLatestMessageLabel()
        setupItemThumbnailImageView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if itemThumbnailImageView.image == nil {
            itemThumbnailImageView.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 25
        
        profileImageView.anchor(leading: self.leadingAnchor, leadingConstant: 20, width: 50,  height: 50)
        profileImageView.centerY(inView: self)
    }
    
    private func setupNicknameLabel() {
        addSubview(nicknameLabel)
        
        nicknameLabel.textColor = .black
        nicknameLabel.numberOfLines = 1
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        nicknameLabel.anchor(top: profileImageView.topAnchor, topConstant: 2, leading: profileImageView.trailingAnchor, leadingConstant: 16)
    }
    
    private func setupLatestMessageLabel() {
        addSubview(latestMessageLabel)
        
        latestMessageLabel.textColor = .black
        latestMessageLabel.numberOfLines = 1
        latestMessageLabel.font = UIFont.systemFont(ofSize: 16)
        
        latestMessageLabel.anchor(bottom: profileImageView.bottomAnchor, bottomConstant: 2, leading: profileImageView.trailingAnchor, leadingConstant: 16)
    }
    
    private func setupItemThumbnailImageView() {
        addSubview(itemThumbnailImageView)
        
        itemThumbnailImageView.contentMode = .scaleAspectFill
        itemThumbnailImageView.layer.cornerRadius = 5
        itemThumbnailImageView.layer.masksToBounds = true
        
        itemThumbnailImageView.anchor(top: topAnchor, topConstant: 15, bottom: bottomAnchor, bottomConstant: 15, leading: latestMessageLabel.trailingAnchor, leadingConstant: 15, trailing: trailingAnchor, trailingConstant: 15, width: 50)
    }
}


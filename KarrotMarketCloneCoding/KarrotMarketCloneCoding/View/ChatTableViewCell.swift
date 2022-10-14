//
//  ChatTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    
    ///프로파일이미지
    let profileImageView = UIImageView()
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
        setupItemThumbnailImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        
        profileImageView.anchor(leading: leadingAnchor, leadingConstant: 15, width: 60,  height: 60)
        profileImageView.centerY(inView: self)
    }
    
    private func setupNicknameLabel() {
        addSubview(nicknameLabel)
        
        nicknameLabel.textColor = .black
        nicknameLabel.numberOfLines = 1
        nicknameLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        
        nicknameLabel.anchor(top: topAnchor, topConstant: 15, leading: profileImageView.trailingAnchor, leadingConstant: 15)
    }
    
    private func setupLatestMessageLabel() {
        addSubview(latestMessageLabel)
        
        latestMessageLabel.textColor = UIColor(white: 0.5, alpha: 0.7)
        latestMessageLabel.numberOfLines = 1
        nicknameLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        
        latestMessageLabel.anchor(bottom: bottomAnchor, bottomConstant: 15, leading: profileImageView.trailingAnchor, leadingConstant: 15)
    }
    
    private func setupItemThumbnailImageView() {
        addSubview(itemThumbnailImageView)
        
        itemThumbnailImageView.contentMode = .scaleAspectFill
        itemThumbnailImageView.layer.cornerRadius = 5
        itemThumbnailImageView..layer.masksToBounds = true
        
        itemThumbnailImageView.anchor(top: topAnchor, topConstant: 15, bottom: bottomAnchor, bottomConstant: 15, leading: latestMessageLabel.trailingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 15, width: 50)
    }
}


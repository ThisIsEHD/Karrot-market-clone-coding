//
//  HomeTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/22.
//

import UIKit
import Alamofire

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "HomeTableViewCell"
    
    var item: FetchedItem? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.title
            priceLabel.text = item.price != 0 ? NumberFormatter.Decimal.string(from: NSNumber(value: item.price))! + "원" : "나눔 🧡"
            wishLabel.text = "\(item.favoriteUserCount)"
            locationLabel.text = item.townName
            
            Task {
                let image = await getThumbnailImage(url: item.imageURL)
                self.thumbnailImageView.image = image ??  UIImage(named: "logo")
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
    }()
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.text = "당근마켓 상품"
        lbl.font = UIFont.systemFont(ofSize: 17)
        return lbl
    }()
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 1
        lb.textColor = .systemGray
        lb.font = UIFont(name: "Helvetica", size: 15)
        return lb
    }()
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = "0 원"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    private let wishIcon: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.imageView?.tintColor = .black.withAlphaComponent(0.6)
        btn.setImage(UIImage(named: "wish-gray"), for: .normal)
        return btn
    }()
    let wishLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .black.withAlphaComponent(0.6)
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    private let chatIcon: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.imageView?.tintColor = .black.withAlphaComponent(0.6)
        btn.setImage(UIImage(named: "chat-gray"), for: .normal)
        return btn
    }()
    private let chatLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = "0"
        lbl.textColor = .black.withAlphaComponent(0.6)
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    // MARK: - Actions
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //  MARK: - Configure Views
    private func configureViews() {
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(priceLabel)
        
        contentView.addSubview(chatIcon)
        contentView.addSubview(chatLabel)
        contentView.addSubview(wishIcon)
        contentView.addSubview(wishLabel)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        setIconStackViewConstraints()
        setContentViewConstraints()
    }
    
    private func setIconStackViewConstraints() {
        wishLabel.anchor(bottom: contentView.bottomAnchor, bottomConstant: 15, trailing: contentView.trailingAnchor, trailingConstant: 10)
        wishIcon.centerY(inView: wishLabel)
        wishIcon.anchor(trailing: wishLabel.leadingAnchor, trailingConstant: 5, width: 18, height: 18)
        
        chatLabel.centerY(inView: wishIcon)
        chatLabel.anchor(trailing: wishIcon.leadingAnchor, trailingConstant: 7)
        
        chatIcon.centerY(inView: chatLabel)
        chatIcon.anchor(trailing: chatLabel.leadingAnchor, trailingConstant: 5, width: 18, height: 18)
    }
    
    private func setContentViewConstraints() {
        thumbnailImageView.anchor(top: contentView.topAnchor, topConstant: 18, bottom: contentView.bottomAnchor, bottomConstant: 18 ,leading: contentView.leadingAnchor, leadingConstant: 18, width: 114)
        
        nameLabel.anchor(top: thumbnailImageView.topAnchor, topConstant: 5,  leading: thumbnailImageView.trailingAnchor, leadingConstant: 15, trailing: trailingAnchor, trailingConstant: 15)
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(nameLabel)
        }
        //        timeLabel.anchor()
        priceLabel.anchor(top: locationLabel.bottomAnchor, topConstant: 10, leading: nameLabel.leadingAnchor)
        
    }
}

//
//  MerchandiseTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/22.
//

import UIKit
import Alamofire

class MerchandiseTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var merchandise: Merchandise? {
        didSet {
            getThumbnailImage { image in
                self.loadData(image: image)
            }
        }
    }
    
    private let thumbnailImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray3
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.text = ""
        lbl.font = UIFont.systemFont(ofSize: 17)
        return lbl
    }()
    
    //        let locationLabel: UILabel = {
    //            let lb = UILabel()
    //            lb.numberOfLines = 1
    //            lb.font = UIFont(name: "Helvetica", size: 13)
    //            return lb
    //        }()
    
    //        let timeLabel: UILabel = {
    //            let lb = UILabel()
    //            lb.numberOfLines = 2
    //            lb.font = UIFont(name: "Helvetica", size: 13)
    //            return lb
    //        }()
    
    let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = ""
        lbl.font = UIFont.systemFont(ofSize: 17)
        return lbl
    }()
    
    private let wishIcon: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "wish-gray"), for: .normal)
        return btn
    }()
    
    let wishLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = ""
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    private let chatIcon: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "chat-gray"), for: .normal)
        return btn
    }()
    
    private let chatLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = ""
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    
    //        let replyIcon: UIButton = {
    //            let bt = UIButton()
    //            bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    //            let size: CGFloat = 19
    //            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    //            bt.imageView?.contentMode = .scaleAspectFit
    //            return bt
    //        }()
    //
    //        let replyLabel: UILabel = {
    //            let lb = UILabel()
    //            lb.numberOfLines = 0
    //            lb.font = UIFont(name: "Helvetica", size: 15)
    //            return lb
    //        }()
    
    private lazy var wishView: UIView = {
        let view = UIView()
        view.addSubview(wishLabel)
        view.addSubview(wishIcon)
        return view
    }()
    
    private lazy var chatView: UIView = {
        let view = UIView()
        view.addSubview(chatLabel)
        view.addSubview(chatIcon)
        return view
    }()
    
    //        lazy var replyView: UIView = {
    //            let view = UIView()
    //            return view
    //        }()
    
    private lazy var iconStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [wishView, chatView])
        sv.axis = .horizontal
        sv.spacing = 3
        sv.alignment = .center
        sv.distribution = .fill
        sv.isUserInteractionEnabled = false
        return sv
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
        [thumbnailImageView, nameLabel, priceLabel, iconStackView].forEach { view in
            contentView.addSubview(view)
        }
    }

    // MARK: - Setting Constraints
    
    private func setConstraints() {
        setIconStackViewConstraints()
        setContentViewConstraints()
    }
    
    private func setIconStackViewConstraints() {
        wishIcon.anchor(top: wishView.topAnchor, bottom: wishView.bottomAnchor, leading: wishView.leadingAnchor, height: 15)
        wishLabel.centerY(inView: wishIcon)
        wishLabel.anchor(leading: wishIcon.trailingAnchor, leadingConstant: 2, trailing: wishView.trailingAnchor)
        
        chatIcon.anchor(top: chatView.topAnchor, bottom: chatView.bottomAnchor, leading: chatView.leadingAnchor, height: 15)
        chatLabel.centerY(inView: chatIcon)
        chatLabel.anchor(leading: chatIcon.trailingAnchor, leadingConstant: 2, trailing: chatView.trailingAnchor)
    }
    
    private func setContentViewConstraints() {
        thumbnailImageView.anchor(top: topAnchor, topConstant: 18, bottom: bottomAnchor, bottomConstant: 18 ,leading: leadingAnchor, leadingConstant: 18, width: 114)
        //width를 동적으로 가져오지 못함 해결해야함.
        
        nameLabel.anchor(top: thumbnailImageView.topAnchor, leading: thumbnailImageView.trailingAnchor, leadingConstant: 15, trailing: trailingAnchor, trailingConstant: 15)
        
//        locationLabel.anchor()
//        timeLabel.anchor()
        priceLabel.anchor(top: nameLabel.bottomAnchor, topConstant: 10, leading: nameLabel.leadingAnchor)
        
        iconStackView.anchor(bottom: bottomAnchor, bottomConstant: 10, trailing: trailingAnchor, trailingConstant: 15)
    }
    
    private func getThumbnailImage(completion: @escaping (UIImage?) -> ()) {
        
        AF.request(merchandise?.images.first?.url ?? "").validate().validate(contentType: ["application/octet-stream"]).responseData { response in
            
            switch response.result {
                
            case .success(let data):
                completion(UIImage(data: data))
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadData(image: UIImage?) {
        
        if let image = image {
            thumbnailImageView.image = image
        }
        nameLabel.text = merchandise?.title
        priceLabel.text = "\(merchandise?.price ?? 0)"
        wishLabel.text = "\(merchandise?.wishes ?? 0)"
    }
}

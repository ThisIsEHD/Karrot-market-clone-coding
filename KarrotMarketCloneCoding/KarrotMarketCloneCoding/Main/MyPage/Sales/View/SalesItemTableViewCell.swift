//
//  SalesItemTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 4/21/23.
//

import UIKit

class SalesItemTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var item: FetchedItem? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.title
            priceLabel.text = item.price != 0 ? NumberFormatter.Decimal.string(from: NSNumber(value: item.price))! + "원" : "나눔 🧡"
            favoriteLabel.text = "\(item.favoriteUserCount)"
            locationLabel.text = item.townName
            
            Task {
                let result = await getImage(url: item.imageURL, size: CGSize(width: 100, height: 100))
                switch result {
                case .success(let image):
                    self.thumbnailImageView.image = image
                case .failure:
                    self.thumbnailImageView.image = UIImage(named: "logo")
                }
            }
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
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
    private let favoriteIcon: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.imageView?.tintColor = .black.withAlphaComponent(0.6)
        btn.setImage(UIImage(named: "wish-gray"), for: .normal)
        return btn
    }()
    let favoriteLabel: UILabel = {
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
    private let hideButton = UIButton()
    private let reserveButton = UIButton()
    private let soldButton = UIButton()
    private let buttomStackView = UIStackView()
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    // MARK: - Actions
    
    @objc
    private func hideButtonDidTapped() {
        print(#function)
    }
    
    @objc
    private func reserveButtonDidTapped() {
        print(#function)
    }
    
    @objc
    private func soldButtonDidTapped() {
        print(#function)
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupButtons()
        setupStackView()
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup
    
    private func setupButtons() {
        hideButton.setTitle("숨기기", for: .normal)
        hideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        hideButton.setTitleColor(.black, for: .normal)
        hideButton.backgroundColor = .white
        hideButton.layer.borderWidth = 0.7
        hideButton.layer.borderColor = UIColor.systemGray5.cgColor
        hideButton.addTarget(self, action: #selector(hideButtonDidTapped), for: .touchUpInside)
        
        reserveButton.setTitle("예약중", for: .normal)
        reserveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        reserveButton.setTitleColor(.black, for: .normal)
        reserveButton.backgroundColor = .white
        reserveButton.layer.borderWidth = 0.7
        reserveButton.layer.borderColor = UIColor.systemGray5.cgColor
        reserveButton.addTarget(self, action: #selector(reserveButtonDidTapped), for: .touchUpInside)
        
        soldButton.setTitle("거래완료", for: .normal)
        soldButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        soldButton.setTitleColor(.black, for: .normal)
        soldButton.backgroundColor = .white
        soldButton.layer.borderWidth = 0.7
        soldButton.layer.borderColor = UIColor.systemGray5.cgColor
        soldButton.addTarget(self, action: #selector(soldButtonDidTapped), for: .touchUpInside)
    }
    
    private func setupStackView() {
        buttomStackView.backgroundColor = .white
        buttomStackView.alignment = .fill
        buttomStackView.axis = .horizontal
        buttomStackView.distribution = .fillEqually
        buttomStackView.spacing = 0
    }
    
    //  MARK: - Configure Views
    
    private func configureViews() {
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(locationLabel)
        containerView.addSubview(priceLabel)
        
        containerView.addSubview(chatIcon)
        containerView.addSubview(chatLabel)
        containerView.addSubview(favoriteIcon)
        containerView.addSubview(favoriteLabel)
        
        buttomStackView.addArrangedSubview(hideButton)
        buttomStackView.addArrangedSubview(reserveButton)
        buttomStackView.addArrangedSubview(soldButton)
        
        contentView.addSubview(buttomStackView)
        
        contentView.addSubview(footerView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(buttomStackView.snp.top)
        }
        
        buttomStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(footerView.snp.top)
            make.height.equalTo(50)
        }
        
        footerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(contentView)
            make.height.equalTo(10)
        }
        
        setIconStackViewConstraints()
        setContentViewConstraints()
    }
    
    private func setIconStackViewConstraints() {
        favoriteLabel.anchor(bottom: containerView.bottomAnchor, bottomConstant: 15, trailing: containerView.trailingAnchor, trailingConstant: 10)
        favoriteIcon.centerY(inView: favoriteLabel)
        favoriteIcon.anchor(trailing: favoriteLabel.leadingAnchor, trailingConstant: 5, width: 18, height: 18)
        
        chatLabel.centerY(inView: favoriteIcon)
        chatLabel.anchor(trailing: favoriteIcon.leadingAnchor, trailingConstant: 7)
        
        chatIcon.centerY(inView: chatLabel)
        chatIcon.anchor(trailing: chatLabel.leadingAnchor, trailingConstant: 5, width: 18, height: 18)
    }
    
    private func setContentViewConstraints() {
        thumbnailImageView.anchor(top: containerView.topAnchor, topConstant: 18, bottom: containerView.bottomAnchor, bottomConstant: 18 ,leading: containerView.leadingAnchor, leadingConstant: 18, width: 114)
        
        nameLabel.anchor(top: thumbnailImageView.topAnchor, topConstant: 5,  leading: thumbnailImageView.trailingAnchor, leadingConstant: 15, trailing: trailingAnchor, trailingConstant: 15)
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(nameLabel)
        }
        priceLabel.anchor(top: locationLabel.bottomAnchor, topConstant: 10, leading: nameLabel.leadingAnchor)
    }
}

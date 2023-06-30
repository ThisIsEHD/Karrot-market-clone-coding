//
//  ItemDetailViewBottomStickyView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/20.
//

import UIKit

class ItemDetailViewBottomStickyView: UIView {
    // MARK: - Properties
    
    weak var delegate: FavoriteButtonDelegate?
    
    private let separaterLine: UIView = {
        
        let v = UIView()
        
        v.backgroundColor = .systemGray4
        
        return v
    }()
    private let favoriteButton: UIButton = {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "wish-gray")?.resize(to: CGSize(width: 30, height: 30)), for: .normal)
        btn.setImage(UIImage(named: "wish-karrot"), for: .selected)
        
        return btn
    }()
    private lazy var stackView: UIStackView = {
        
        let sv = UIStackView(arrangedSubviews: [priceLabel, priceOfferButton])
        
        sv.contentMode = .left
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 2
        
        return sv
    }()
    private let priceLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.text = "0 원"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        
        return lbl
    }()
    private let priceOfferButton: UIButton = {
        
        let btn = UIButton()
        
        btn.setTitle("가격제안불가", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(.systemGray2, for: .normal)
        
        return btn
    }()
    private let chatButton: UIButton = {
        
        let btn = UIButton()
        
        btn.setTitle("채팅하기", for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 10
        
        return btn
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonDidTapped), for: .touchUpInside)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func favoriteButtonDidTapped() {
        
        if !favoriteButton.isSelected {
            delegate?.addFavoriteList()
        } else {
            delegate?.deleteFavoriteList()
        }
    }
    
    func getFavoriteButton() -> UIButton {
        return favoriteButton
    }
    
    func configure(price: Int?) {
        guard let price = price else {
            priceLabel.text = "나눔 🧡"
            return
        }
        
        priceLabel.text = price != 0 ? NumberFormatter.Decimal.string(from: NSNumber(value: price))! + "원" : "나눔 🧡"
    }
    
    //  MARK: - configure Views
    func configureViews() {
        
        self.backgroundColor = .systemBackground
        self.addSubview(separaterLine)
        self.addSubview(favoriteButton)
        self.addSubview(stackView)
        self.addSubview(chatButton)
    }
    
    // MARK: - Setting Constraints
    func setConstraints() {
        
        separaterLine.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 0.7)
        favoriteButton.anchor(leading: self.leadingAnchor, leadingConstant: 20, width: 20, height: 20)
        favoriteButton.centerY(inView: stackView)
        
        stackView.anchor(top: self.topAnchor, topConstant: 20, bottom: self.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20, leading: favoriteButton.trailingAnchor, leadingConstant: 30)
        
        chatButton.anchor(top: stackView.topAnchor, bottom: stackView.bottomAnchor, trailing: self.trailingAnchor, trailingConstant: 30, width: 100)
    }
}

//
//  MerchandiseDetailViewBottomStickyView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/20.
//

import UIKit

class MerchandiseDetailViewBottomStickyView: UIView {
// MARK: - Properties
    
    let separaterLine = UIView()
    let wishButton = UIButton()
    lazy var stackView = UIStackView(arrangedSubviews: [priceLabel, priceOfferButton])
    let priceLabel = UILabel()
    let priceOfferButton = UIButton()
    let chatButton = UIButton()
    
// MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//  MARK: - Setup Views
    func setupViews() {
        self.backgroundColor = .systemBackground
        self.addSubview(separaterLine)
        self.addSubview(wishButton)
        self.addSubview(stackView)
        self.addSubview(chatButton)
        
        separaterLine.backgroundColor = .systemGray
        wishButton.setImage(UIImage(named: "logo"), for: .normal)
        
        priceLabel.text = "0원"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        priceOfferButton.setTitle("가격제안불가", for: .normal)
        priceOfferButton.setTitleColor(.systemGray2, for: .normal)
        
        stackView.contentMode = .left
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        chatButton.setTitle("채팅하기", for: .normal)
        chatButton.backgroundColor = .orange
        chatButton.layer.cornerRadius = 10
        
    }
    
// MARK: - Setup Constraints
    func setupConstraints() {
        separaterLine.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 1)
        wishButton.anchor(leading: self.leadingAnchor, leadingConstant: 20, width: 30, height: 30)
        wishButton.centerY(inView: stackView)
        
        stackView.anchor(top: self.topAnchor, topConstant: 20, bottom: self.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20, leading: wishButton.trailingAnchor, leadingConstant: 30)
        
        chatButton.anchor(top: stackView.topAnchor, bottom: stackView.bottomAnchor, trailing: self.trailingAnchor, trailingConstant: 30, width: 100)
    }
}

//
//  ItemDetailViewBottomStickyView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/20.
//

import UIKit

class ItemDetailViewBottomStickyView: UIView {
// MARK: - Properties
    
    private let separaterLine: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray
        return v
    }()
    
    private let wishButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "logo"), for: .normal)
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
        lbl.text = "0원"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    private let priceOfferButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("가격제안불가", for: .normal)
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
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//  MARK: - configure Views
    func configureViews() {
        self.backgroundColor = .systemBackground
        self.addSubview(separaterLine)
        self.addSubview(wishButton)
        self.addSubview(stackView)
        self.addSubview(chatButton)
    }
    
// MARK: - Setting Constraints
    func setConstraints() {
        separaterLine.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 1)
        wishButton.anchor(leading: self.leadingAnchor, leadingConstant: 20, width: 30, height: 30)
        wishButton.centerY(inView: stackView)
        
        stackView.anchor(top: self.topAnchor, topConstant: 20, bottom: self.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20, leading: wishButton.trailingAnchor, leadingConstant: 30)
        
        chatButton.anchor(top: stackView.topAnchor, bottom: stackView.bottomAnchor, trailing: self.trailingAnchor, trailingConstant: 30, width: 100)
    }
}

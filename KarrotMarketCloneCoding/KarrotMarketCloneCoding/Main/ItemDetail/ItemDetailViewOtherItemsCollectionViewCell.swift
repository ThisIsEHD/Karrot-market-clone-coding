//
//  ItemDetailViewOtherItemsCollectionViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/20.
//

import UIKit

class ItemDetailViewOtherItemsCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let itemImageView: UIImageView = {
        
        let iv = UIImageView()
        
        iv.image = UIImage(named: "sold")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        
        return iv
    }()
    private let itemNameLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.font = UIFont.systemFont(ofSize: 16)
        
        return lbl
    }()
    private let priceLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.text = "20,000원"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(itemImageView)
        addSubview(itemNameLabel)
        addSubview(priceLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func configure(image: UIImage?, title: String?, price: Int?) {
        
        itemImageView.image = image
        itemNameLabel.text = title
        priceLabel.text  = price != nil ? "\(price ?? 0) 원" : "무료 나눔🧡"
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        itemImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, height: 150)
        itemNameLabel.anchor(top: itemImageView.bottomAnchor, topConstant: 15, leading: itemImageView.leadingAnchor, trailing: itemImageView.trailingAnchor)
        priceLabel.anchor(top: itemNameLabel.bottomAnchor, topConstant: 10, bottom: bottomAnchor, leading: itemNameLabel.leadingAnchor, trailing: itemNameLabel.trailingAnchor)
    }
}


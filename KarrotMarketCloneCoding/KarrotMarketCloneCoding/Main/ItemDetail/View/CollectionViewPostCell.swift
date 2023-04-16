//
//  ItemDetailViewOtherItemsCollectionViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/20.
//

import UIKit

class CollectionViewPostCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "PostCell"
    
    private let itemImageView: UIImageView = {
     
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        
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
    
    func configure(title: String?, price: Int?) {
        itemNameLabel.text = title
        
        guard let price = price else {
            priceLabel.text = "나눔 🧡"
            return
        }
        
        priceLabel.text = price != 0 ? NumberFormatter.Decimal.string(from: NSNumber(value: price))! + "원" : "나눔 🧡"
    }
    
    func loadImage(_ image: UIImage) {
        self.itemImageView.image = image
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        itemImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, height: 150)
        itemNameLabel.anchor(top: itemImageView.bottomAnchor, topConstant: 15, leading: itemImageView.leadingAnchor, trailing: itemImageView.trailingAnchor)
        priceLabel.anchor(top: itemNameLabel.bottomAnchor, topConstant: 10, bottom: bottomAnchor, leading: itemNameLabel.leadingAnchor, trailing: itemNameLabel.trailingAnchor)
    }
}


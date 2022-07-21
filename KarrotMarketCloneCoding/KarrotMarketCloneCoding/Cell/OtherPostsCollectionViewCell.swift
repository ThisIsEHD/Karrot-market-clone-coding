//
//  OtherPostsCollectionViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/20.
//

import UIKit

class OtherPostsCollectionViewCell: UICollectionViewCell {
//MARK: - Properties
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sold")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let postNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "당근당근당근당근당근당근당근"
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "20,000원"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
//MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImageView)
        addSubview(postNameLabel)
        addSubview(priceLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - Configure UI
extension OtherPostsCollectionViewCell {
    private func setupConstraints() {
        postImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, height: 150)
        postNameLabel.anchor(top: postImageView.bottomAnchor, topConstant: 15, leading: postImageView.leadingAnchor, trailing: postImageView.trailingAnchor)
        priceLabel.anchor(top: postNameLabel.bottomAnchor, topConstant: 10, bottom: bottomAnchor, leading: postNameLabel.leadingAnchor, trailing: postNameLabel.trailingAnchor)
    }
}


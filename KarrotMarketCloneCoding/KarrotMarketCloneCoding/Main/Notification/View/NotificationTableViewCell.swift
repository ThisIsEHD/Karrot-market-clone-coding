//
//  NotificationTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/23.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationTableViewCell"
    
    let imgView: UIImageView = {
        
        let imgView = UIImageView()
        
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 27
        
        return imgView
    }()
    let desciptionLabel = UILabel()
    let dateLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(imgView)
        addSubview(desciptionLabel)
        addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupImageViewLayout()
        setupDescriptionLabelLayout()
        setupDateLabelLayout()
    }
    
    func setupImageViewLayout() {
        
        imgView.anchor(top: topAnchor, topConstant: 30, leading: leadingAnchor, leadingConstant: 5, width: 54, height: 54)
    }
    
    func setupDescriptionLabelLayout() {
        
        desciptionLabel.anchor(top: imgView.topAnchor, leading: imgView.trailingAnchor, leadingConstant: 5, trailing: trailingAnchor, trailingConstant: 5)
    }
    
    func setupDateLabelLayout() {
        
        dateLabel.anchor(top: desciptionLabel.bottomAnchor, topConstant: 5 ,leading: desciptionLabel.leadingAnchor)
    }
}

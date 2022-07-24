//
//  MerchandiseDetailViewProfileCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

class MerchandiseDetailViewProfileCell: UITableViewCell {
    // MARK: - Properties
    
    private lazy var profileView: UIView = {
        let v = ReusableProfileView(imageSize: 50)
        return v
    }()
    
    // MARK: - Actions
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(profileView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //  MARK: - Set Constraints
    private func setConstraints() {
        profileView.anchor(top: topAnchor, topConstant: 40, bottom: bottomAnchor, bottomConstant: 40, leading: leadingAnchor, trailing: trailingAnchor)
    }
}

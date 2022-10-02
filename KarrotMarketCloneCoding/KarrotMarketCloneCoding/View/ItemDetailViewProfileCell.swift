//
//  ItemDetailViewProfileCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

class ItemDetailViewProfileCell: UITableViewCell {
    // MARK: - Properties
    
    private lazy var profileView: ReusableProfileView = {
        let v = ReusableProfileView(imageSize: 50)
        return v
    }()
    
    // MARK: - Actions
    
    func setProfile(nickname: String?, image: UIImage?) {
        profileView.configure(nickname: nickname)
        profileView.configure(image: image)
    }
    
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
    
    //  MARK: - Setting Constraints
    private func setConstraints() {
        profileView.anchor(top: topAnchor, topConstant: 40, bottom: bottomAnchor, bottomConstant: 40, leading: leadingAnchor, trailing: trailingAnchor)
    }
}

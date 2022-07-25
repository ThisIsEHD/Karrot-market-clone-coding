//
//  MerchandiseDescriptionCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

class MerchandiseDescriptionCell: UITableViewCell {
    // MARK: - Properties
    private let merchandiseNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "애플 충전기"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    private let merchandiseCategoryButton: UIButton = {
        let btn = UIButton()
        let attributedString = NSMutableAttributedString(string: "디지털기기", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 13)])
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.setTitleColor(UIColor.systemGray2, for: .normal)
        return btn
    }()
    
    private let merchandiseDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.text = "미개봉 새제품입니다\n거래가능하시면 연락주세요\n장소는 아무데나 가능합니다."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    
    private let extraInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "2 chasts, 6 favorites, 114 views"
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .systemGray2
        return lbl
    }()
    // MARK: - Actions
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    // MARK: - Configure Views
    private func configureViews() {
        addSubview(merchandiseNameLabel)
        addSubview(merchandiseCategoryButton)
        addSubview(merchandiseDescriptionTextView)
        addSubview(extraInfoLabel)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        merchandiseNameLabel.anchor(top: self.topAnchor, topConstant: 20, leading: self.leadingAnchor, leadingConstant: 15)
        merchandiseCategoryButton.anchor(top: merchandiseNameLabel.bottomAnchor, topConstant: 15, leading: merchandiseNameLabel.leadingAnchor)
        merchandiseDescriptionTextView.anchor(top: merchandiseCategoryButton.bottomAnchor, topConstant: 15, leading: merchandiseCategoryButton.leadingAnchor, trailing: self.trailingAnchor, trailingConstant: 20)
        extraInfoLabel.anchor(top: merchandiseDescriptionTextView.bottomAnchor, topConstant: 15, bottom: self.bottomAnchor, bottomConstant: 30, leading: merchandiseCategoryButton.leadingAnchor)
    }
}

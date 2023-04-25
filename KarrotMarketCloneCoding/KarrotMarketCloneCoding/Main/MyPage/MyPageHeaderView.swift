//
//  MyPageHeaderView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/14.
//

import UIKit

final class MyPageHeaderView: UIView {
    
    // MARK: Properties
    
    weak var delegate: ProfileViewDelegate?
    
    private lazy var profileView: ReusableProfileView = {
        
        let v = ReusableProfileView(imageSize: 80)
        
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileViewDidTapped)))
        
        return v
    }()
    private let indicatorImageView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "indicator"))
        
        return iv
    }()
    private let salesListImageView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "sold"))
        
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60 / 2
        
        return iv
    }()
    private let salesListLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.text = ItemList.sales.title
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 15)
        
        return lbl
    }()
    private lazy var salesListStackView: UIStackView = {
        
        let sv = UIStackView(arrangedSubviews: [salesListImageView, salesListLabel])
        
        sv.axis = .vertical
        sv.spacing = 10
        sv.tag = 0
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stackViewDidTapped(_:))))
        
        return sv
    }()
    private let purchaseListImageView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "purchase"))
        
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60 / 2
        
        return iv
    }()
    private let purchaseListLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.text = ItemList.purchase.title
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 15)
        
        return lbl
    }()
    private lazy var purchaseListStackView: UIStackView = {
        
        let sv = UIStackView(arrangedSubviews: [purchaseListImageView, purchaseListLabel])
        
        sv.axis = .vertical
        sv.isUserInteractionEnabled = true
        sv.spacing = 10
        sv.tag = 1
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stackViewDidTapped(_:))))
        
        return sv
    }()
    private let favoriteListImageView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "wish"))
        
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60 / 2
        
        return iv
    }()
    private let favoriteListLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.text = ItemList.favorite.title
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 15)
        
        return lbl
    }()
    private lazy var favoriteListStackView: UIStackView = {
        
        let sv = UIStackView(arrangedSubviews: [favoriteListImageView, favoriteListLabel])
        
        sv.axis = .vertical
        sv.isUserInteractionEnabled = true
        sv.spacing = 10
        sv.tag = 2
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stackViewDidTapped(_:))))
        
        return sv
    }()
    
    // MARK: Actions
    
    @objc func profileViewDidTapped() {
        self.delegate?.goToMyProfileVC()
    }
    
    @objc func stackViewDidTapped(_ sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            delegate?.selectedItemTableVC(.sales)
        case 1:
            print("api가 아직 없음.")
            //  delegate?.selectedItemTableVC(.buy)
        case 2:
            delegate?.selectedItemTableVC(.favorite)
        default:
            break
        }
    }
    
    func configureUser(nickname: String?) {
        profileView.configure(nickname: nickname)
    }
    
    func configureUser(image: UIImage?) {
        profileView.configure(image: image)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        setConstraints()
    }
    
    convenience init(width: Double, height: Double) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        
        backgroundColor = .systemBackground
        addSubview(profileView)
        addSubview(salesListStackView)
        addSubview(purchaseListStackView)
        addSubview(favoriteListStackView)
        
        profileView.addSubview(indicatorImageView)
    }
    
    // MARK: Setting Constraints
    
    private func setConstraints() {
        
        setProfileViewConstraints()
        setIndicatorViewConstraints()
        setProfileStackViewConstraints()
    }
    
    private func setProfileViewConstraints() {
        
        profileView.anchor(top: self.safeAreaLayoutGuide.topAnchor,
                           leading: self.safeAreaLayoutGuide.leadingAnchor,
                           trailing: self.safeAreaLayoutGuide.trailingAnchor)
    }
    
    private func setIndicatorViewConstraints() {
        
        indicatorImageView.anchor(trailing: profileView.trailingAnchor,
                                  trailingConstant: 20,
                                  width: 15, height: 15)
        indicatorImageView.centerY(inView: profileView)
    }
    
    private func setProfileStackViewConstraints() {
        
        let width = (self.frame.width - (60 * 3)) / 4
        
        salesListImageView.centerX(inView: salesListStackView)
        salesListImageView.anchor(height: 60)
        salesListLabel.centerX(inView: salesListImageView)
        salesListStackView.anchor(top: profileView.bottomAnchor, topConstant: 15,
                                 bottom: self.safeAreaLayoutGuide.bottomAnchor,
                                 bottomConstant: 15,
                                 leading: self.safeAreaLayoutGuide.leadingAnchor,
                                 leadingConstant: width,
                                 width: 60)
        
        purchaseListImageView.centerX(inView: purchaseListStackView)
        purchaseListImageView.anchor(height: 60)
        purchaseListLabel.centerX(inView: purchaseListImageView)
        purchaseListStackView.anchor(top: salesListImageView.topAnchor,
                                     bottom: self.safeAreaLayoutGuide.bottomAnchor,
                                     bottomConstant: 20,
                                     leading: salesListStackView.trailingAnchor,
                                     leadingConstant: width,
                                     width: 60)
        
        favoriteListImageView.centerX(inView: favoriteListStackView)
        favoriteListImageView.anchor(height: 60)
        favoriteListLabel.centerX(inView: favoriteListImageView)
        favoriteListStackView.anchor(top: salesListImageView.topAnchor,
                                 bottom: self.safeAreaLayoutGuide.bottomAnchor,
                                 bottomConstant: 20,
                                 leading: purchaseListStackView.trailingAnchor,
                                 leadingConstant: width,
                                 width: 60)
    }
}

// MARK: - ProfileViewDelegate

protocol ProfileViewDelegate: AnyObject {
    
    func goToMyProfileVC()
    func selectedItemTableVC(_ title: ItemList)
    func configureUserInfo()
}

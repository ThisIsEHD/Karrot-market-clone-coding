//
//  NewPostTableView.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/23.
//

import UIKit

final class NewPostTableView: UIView {
     
    internal let tableView: UITableView = {
        
       let tableView = UITableView()
        
        tableView.register(PhotosSelectingTableViewCell.nib() , forCellReuseIdentifier: PhotosSelectingTableViewCell.identifier)
        tableView.register(TitleTableViewCell.nib(), forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.register(PriceTableViewCell.nib(), forCellReuseIdentifier: PriceTableViewCell.identifier)
        tableView.register(DetailTableViewCell.nib(), forCellReuseIdentifier: DetailTableViewCell.identifier)
        
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
    }
}

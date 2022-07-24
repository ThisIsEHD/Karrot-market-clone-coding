//
//  NotificationTableView.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/23.
//

import UIKit

final class NotificationTableView: UIView {
    
    internal let tableView: UITableView = {
        
       let tableView = UITableView()
        
        tableView.register(NotificationTableViewCell.self , forCellReuseIdentifier: NotificationTableViewCell.identifier)
        tableView.rowHeight = 135
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .systemBackground
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
    }
}

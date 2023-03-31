//
//  NewPostTableView.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/23.
//

import UIKit

final class NewPostTableView: UITableView {
     
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        self.register(PhotosSelectingTableViewCell.nib() , forCellReuseIdentifier: PhotosSelectingTableViewCell.identifier)
        self.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        self.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
        self.register(PriceTableViewCell.self, forCellReuseIdentifier: PriceTableViewCell.identifier)
        self.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        self.register(LocationSelectTableViewCell.self, forCellReuseIdentifier: LocationSelectTableViewCell.identifier)
    }

  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

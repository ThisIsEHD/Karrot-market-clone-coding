//
//  LocationSelectTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/21/23.
//

import UIKit

final class LocationSelectTableViewCell: UITableViewCell {
    
    static let identifier = "LocationSelectTableViewCell"
    
    let locationLabel = UILabel()
    var location: String? {
        didSet {
            guard let location = location else { return }
            locationLabel.text = location
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        locationLabel.text = location ?? "장소 선택"
        locationLabel.textColor = .systemGray
        
        contentView.addSubview(locationLabel)
        
        locationLabel.centerY(inView: contentView)
        locationLabel.anchor(trailing: contentView.trailingAnchor, trailingConstant: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

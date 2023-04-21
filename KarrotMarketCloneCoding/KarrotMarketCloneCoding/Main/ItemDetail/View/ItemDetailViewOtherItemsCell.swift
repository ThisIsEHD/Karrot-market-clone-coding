//
//  ItemDetailViewOtherItemsCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

protocol ErrorPresentable: AnyObject {
    func presentError(error: KarrotError)
}

class ItemDetailViewOtherItemsCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "ItemDetailViewOtherItemsCell"
    
    weak var delegate: ErrorPresentable?
    
    var items: [FetchedItem]? {
        didSet {
            postsCollectionView.reloadData()
        }
    }
    
    let titleLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.font = UIFont.boldSystemFont(ofSize: 19)
        
        return lbl
    }()
    
    private let postsCollectionView: UICollectionView = {
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        cv.register(CollectionViewPostCell.self, forCellWithReuseIdentifier: "PostCell")
        
        return cv
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(postsCollectionView)
        
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setting Constraints
    
    private func setupConstraints() {
        
        titleLabel.anchor(top: topAnchor, topConstant: 20, leading: leadingAnchor, leadingConstant: 15)
        postsCollectionView.anchor(top: titleLabel.bottomAnchor, topConstant: 15, bottom: self.bottomAnchor, bottomConstant: 20, leading: titleLabel.leadingAnchor, trailing: self.trailingAnchor, trailingConstant: 20, height: 230)
    }
}

// MARK: - UICollectionViewDataSource

extension ItemDetailViewOtherItemsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewPostCell.identifier, for: indexPath) as? CollectionViewPostCell else { return UICollectionViewCell() }
        
        let item = items?[indexPath.row]
        
        cell.configure(title: item?.title, price: item?.price)
        
        if let imageURL = item?.imageURL {
            
            Task {
                let result = await getImage(url: imageURL)
                
                switch result {
                case .success(let image):
                    cell.loadImage(image)
                case .failure(let error):
                    self.delegate?.presentError(error: error)
                }
            }
        }
    
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ItemDetailViewOtherItemsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        
        let frame = collectionView.frame
        let width = (frame.width - (layout.sectionInset.right + layout.sectionInset.left) - layout.minimumInteritemSpacing * 2) / 2
        let size = CGSize(width: width, height: 210)
        
        return size
    }
}

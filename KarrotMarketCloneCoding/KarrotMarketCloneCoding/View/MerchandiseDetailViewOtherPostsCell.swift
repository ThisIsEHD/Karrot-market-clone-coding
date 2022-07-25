//
//  MerchandiseDetailViewPostsCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

class MerchandiseDetailViewOtherPostsCell: UITableViewCell {
    
    // MARK: - Properties
    let tableTitlelabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 19)
        return lbl
    }()
    
    private let postsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(OtherPostsCollectionViewCell.self, forCellWithReuseIdentifier: "PostCell")
        return cv
    }()
    
    // MARK: - Actions
    
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(tableTitlelabel)
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
        tableTitlelabel.anchor(top: topAnchor, topConstant: 20, leading: leadingAnchor, leadingConstant: 15)
        postsCollectionView.anchor(top: tableTitlelabel.bottomAnchor, topConstant: 15, bottom: self.bottomAnchor, bottomConstant: 20, leading: tableTitlelabel.leadingAnchor, trailing: self.trailingAnchor, trailingConstant: 20, height: 230)
    }
}

// MARK: - UICollectionViewDataSource

extension MerchandiseDetailViewOtherPostsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! OtherPostsCollectionViewCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MerchandiseDetailViewOtherPostsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        
        let frame = collectionView.frame
        let width = (frame.width - (layout.sectionInset.right + layout.sectionInset.left) - layout.minimumInteritemSpacing * 2) / 2
        
        let size = CGSize(width: width, height: 210)
        return size
    }
}

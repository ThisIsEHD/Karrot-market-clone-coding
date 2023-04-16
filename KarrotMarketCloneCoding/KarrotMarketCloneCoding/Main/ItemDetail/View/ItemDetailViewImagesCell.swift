//
//  ItemImageTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 4/14/23.
//

import UIKit

typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, UIImage>
typealias CollectionViewSnapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
typealias CollectionViewCellProvider = (UICollectionView, IndexPath, UIImage) -> UICollectionViewCell

class ItemDetailViewImagesCell: UITableViewCell {
    
    static let identifier = "ItemDetailViewImagesCell"
    var images: [UIImage] = [] {
        didSet {
            var snapshot = CollectionViewSnapshot()
            
            snapshot.appendSections([Section.main])
            snapshot.appendItems(images)
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
            pageControl.numberOfPages = images.count
        }
    }
    
    private var dataSource: CollectionViewDataSource!
    private var snapshot = CollectionViewSnapshot()
    private var cellProvider: CollectionViewCellProvider = { (collectionView, indexPath, image) in

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemImageCollectionViewCell

        cell.imageView.image = image

        return cell
    }
    
    private let itemImagesCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        cv.showsHorizontalScrollIndicator = false
        cv.register(ItemImageCollectionViewCell.self, forCellWithReuseIdentifier: ItemImageCollectionViewCell.reuseIdentifier)
        cv.isPagingEnabled = true
        
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        
        let pc = UIPageControl()
        
        pc.currentPage = 0
        pc.pageIndicatorTintColor = UIColor(white: 0.4, alpha: 0.4)
        pc.currentPageIndicatorTintColor = .white
        
        return pc
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(itemImagesCollectionView)
        contentView.addSubview(pageControl)
        
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: itemImagesCollectionView, cellProvider: cellProvider)
        
        itemImagesCollectionView.dataSource = dataSource
        itemImagesCollectionView.delegate = self
        
        itemImagesCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.width.equalTo(UIScreen.main.bounds.width)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemDetailViewImagesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}

extension ItemDetailViewImagesCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == itemImagesCollectionView {

            let width = scrollView.bounds.size.width
            let x = scrollView.contentOffset.x + (width/2.0)
            let newPage = Int(x / width)

            if pageControl.currentPage != newPage {
                pageControl.currentPage = newPage
            }
        }
    }
}



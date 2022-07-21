//
//  MerchandiseDetailTableHeaderView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/20.
//

import UIKit

class MerchandiseDetailTableHeaderView: UIView {
    
// MARK: - Properties
    private let containerView = UIView()
    
    ///이미지 컬렉션뷰를 여기서 관리할 경우!
//    private let imageCollectionView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        return cv
//    }()
    
// MARK: - Actions
    func scrollViewDidScroll(scrollView: UIScrollView, pageControl: UIPageControl) {
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width/2.0)
        let newPage = Int(x / width)
        
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
    
    
// MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
//        containerView.addSubview(imageCollectionView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// MARK: - Configure UI

extension MerchandiseDetailTableHeaderView {
    private func setupConstraints() {
        containerView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor)
        
//        imageCollectionView.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor)
    }
}

//
//  MerchandiseDetailViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

class MerchandiseDetailViewController: UIViewController, UITableViewDelegate {
// MARK: - Properties
    
    private let list = [UIColor.red, UIColor.green, UIColor.blue, UIColor.gray, UIColor.black]
    
    var merchandise: Merchandise?
    
    private let imageListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(MerchandiseDetailViewImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        cv.isPagingEnabled = true
        return cv
    }()
    
    private lazy var imageListpageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = list.count
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .systemGray5
        pc.currentPageIndicatorTintColor = .white
        return pc
    }()
    
    private let contentListView: UITableView = {
        let tv = UITableView()
        tv.register(MerchandiseDetailViewProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tv.register(MerchandiseDescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
        tv.register(MerchandiseDetailViewOtherPostsCell.self, forCellReuseIdentifier: "PostCell")
        // contentInset이 조정되지 않아 테이블뷰의 topAnchor가 superview의 topAnchor와 같아짐
        tv.contentInsetAdjustmentBehavior = .never
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()
    
    private lazy var merchandiseDetailTableHeaderView: UIView = {
        let v = MerchandiseDetailTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        v.addSubview(imageListCollectionView)
        v.addSubview(imageListpageControl)
        return v
    }()
    
    private let merchandiseDetailViewBottomStickyView = MerchandiseDetailViewBottomStickyView()
    
// MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        setNavigationColorByHeight(contentListView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = .none
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        contentListView.dataSource = self
        // ScrollviewDelegate 사용을 위해
        contentListView.delegate = self
        contentListView.tableHeaderView = merchandiseDetailTableHeaderView
        
        imageListCollectionView.dataSource = self
        imageListCollectionView.delegate = self
        
        view.addSubview(contentListView)
        view.addSubview(merchandiseDetailViewBottomStickyView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        setImageListCollectionViewConstraints()
        setImageListpageControlConstraints()
        setContentListConstraints()
        setBottomStickyViewConstraints()
    }
    
    private func setImageListCollectionViewConstraints() {
        imageListCollectionView.anchor(top: contentListView.tableHeaderView?.topAnchor, bottom: contentListView.tableHeaderView?.bottomAnchor, leading: contentListView.tableHeaderView?.leadingAnchor, trailing: contentListView.tableHeaderView?.trailingAnchor)
    }
    
    private func setImageListpageControlConstraints() {
        imageListpageControl.anchor(bottom: imageListCollectionView.bottomAnchor)
        imageListpageControl.centerX(inView: imageListCollectionView)
    }
    
    private func setContentListConstraints() {
        contentListView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setBottomStickyViewConstraints() {
        merchandiseDetailViewBottomStickyView.anchor(bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 120)
        
    }
    
    func setNavigationColorByHeight(_ sender: UIScrollView) {
        if sender.contentOffset.y > 280 {
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.shadowImage = .none
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.isTranslucent = false
            
        }
        else {
            navigationController?.isNavigationBarHidden = true
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.isTranslucent = true
        }
    }
}
// MARK: - UICollectionViewDataSource

extension MerchandiseDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        cell.backgroundColor = list[indexPath.row]
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MerchandiseDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UITableViewDataSource

extension MerchandiseDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! MerchandiseDetailViewProfileCell
                cell.selectionStyle = .none
                return cell

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! MerchandiseDescriptionCell
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! MerchandiseDetailViewOtherPostsCell
                cell.selectionStyle = .none
                cell.tableTitlelabel.text = "욘두님의 판매 상품"
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! MerchandiseDetailViewOtherPostsCell
                cell.selectionStyle = .none
                cell.tableTitlelabel.text = "OO님, 이건어때요?"
                return cell
            default:
                return UITableViewCell()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension MerchandiseDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.contentListView.tableHeaderView as! MerchandiseDetailTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView, pageControl: imageListpageControl)
        print(#function)
        
        setNavigationColorByHeight(scrollView)
    }
}

//
//  MerchandiseDetailViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

class MerchandiseDetailViewController: UIViewController {
// MARK: - Properties
    
    private let list = [UIColor.red, UIColor.green, UIColor.blue, UIColor.gray, UIColor.black]
    
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
        pc.pageIndicatorTintColor = .systemGray5
        pc.currentPageIndicatorTintColor = .white
        return pc
    }()
    
    private let contentListView: UITableView = {
        let tv = UITableView()
        tv.register(MerchandiseDetailViewProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tv.register(MerchandiseDescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
        tv.register(MerchandiseDetailViewOtherPostsCell.self, forCellReuseIdentifier: "PostCell")
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 200
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()
    
    private let merchandiseDetailViewBottomStickyView = MerchandiseDetailViewBottomStickyView()
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentListView.dataSource = self
        imageListCollectionView.dataSource = self
        imageListCollectionView.delegate = self
        
        view.addSubview(contentListView)
        view.addSubview(merchandiseDetailViewBottomStickyView)
        
        let headerView = MerchandiseDetailTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        
        headerView.addSubview(imageListCollectionView)
        headerView.addSubview(imageListpageControl)
        
        contentListView.tableHeaderView = headerView
        imageListpageControl.currentPage = 0
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Configure UI

extension MerchandiseDetailViewController {
    private func setupConstraints() {
        setupImageListCollectionViewConstraints()
        setupImageListpageControlConstraints()
        setupContentListConstraints()
        setupBottomStickyViewConstraints()
    }
    
    private func setupImageListCollectionViewConstraints() {
        imageListCollectionView.anchor(top: contentListView.tableHeaderView?.topAnchor, bottom: contentListView.tableHeaderView?.bottomAnchor, leading: contentListView.tableHeaderView?.leadingAnchor, trailing: contentListView.tableHeaderView?.trailingAnchor)
    }
    
    private func setupImageListpageControlConstraints() {
        imageListpageControl.anchor(bottom: imageListCollectionView.bottomAnchor)
        imageListpageControl.centerX(inView: imageListCollectionView)
    }
    
    private func setupContentListConstraints() {
        contentListView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupBottomStickyViewConstraints() {
        merchandiseDetailViewBottomStickyView.anchor(bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 120)
        
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


extension MerchandiseDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.contentListView.tableHeaderView as! MerchandiseDetailTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView, pageControl: imageListpageControl)
    }
}

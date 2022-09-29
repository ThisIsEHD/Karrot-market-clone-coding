//
//  ItemDetailViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit
import Alamofire

class ItemDetailViewController: UIViewController, UITableViewDelegate {
// MARK: - Properties

    var item: Item? {
        didSet {
            
        }
    }
    
    private let imageListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(ItemDetailViewImageCell.self, forCellWithReuseIdentifier: "ItemDetailViewImageCell")
        cv.isPagingEnabled = true
        return cv
    }()
    
    private lazy var imageListpageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = item?.images?.count ?? 1
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .systemGray5
        pc.currentPageIndicatorTintColor = .white
        return pc
    }()
    
    private let contentListView: UITableView = {
        let tv = UITableView()
        tv.register(ItemDetailViewProfileCell.self, forCellReuseIdentifier: "ItemDetailViewProfileCell")
        tv.register(ItemDescriptionCell.self, forCellReuseIdentifier: "ItemDescriptionCell")
        tv.register(ItemDetailViewOtherPostsCell.self, forCellReuseIdentifier: "ItemDetailViewOtherPostsCell")
        
        tv.contentInsetAdjustmentBehavior = .never
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()
    
    private lazy var itemDetailTableHeaderView: UIView = {
        let v = ItemDetailTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        v.addSubview(imageListCollectionView)
        v.addSubview(imageListpageControl)
        return v
    }()
    
    let statusBarView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height))
    
    private let itemDetailViewBottomStickyView = ItemDetailViewBottomStickyView()
    
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
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = .none
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        contentListView.dataSource = self
        // ScrollviewDelegate 사용을 위해
        contentListView.delegate = self
        contentListView.tableHeaderView = itemDetailTableHeaderView
        
        imageListCollectionView.dataSource = self
        imageListCollectionView.delegate = self
        
        
        view.addSubview(contentListView)
        view.addSubview(itemDetailViewBottomStickyView)
        
        statusBarView.backgroundColor = .systemBackground
        statusBarView.alpha = 0
        view.addSubview(statusBarView)
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
        contentListView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, bottomConstant: 120, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setBottomStickyViewConstraints() {
        itemDetailViewBottomStickyView.anchor(bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 120)
        
    }
    
    func setNavigationColorByHeight(_ sender: UIScrollView) {
        
        if sender.contentOffset.y >= 300 {
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.shadowImage = .none
            self.statusBarView.alpha = 1
        }
        else {
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.statusBarView.alpha = 0
        }
    }
}
// MARK: - UICollectionViewDataSource

extension ItemDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.images?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailViewImageCell", for: indexPath) as! ItemDetailViewImageCell
        
        
        AF.request(item?.images?.first?.url ?? "").validate().validate(contentType: ["application/octet-stream"]).responseData { response in
            
            switch response.result {
                    
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
            }
        }
        
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ItemDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UITableViewDataSource

extension ItemDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewProfileCell", for: indexPath) as! ItemDetailViewProfileCell
                cell.selectionStyle = .none
                return cell

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDescriptionCell", for: indexPath) as! ItemDescriptionCell
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewOtherPostsCell", for: indexPath) as! ItemDetailViewOtherPostsCell
                cell.selectionStyle = .none
                cell.tableTitlelabel.text = "욘두님의 판매 상품"
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewOtherPostsCell", for: indexPath) as! ItemDetailViewOtherPostsCell
                cell.selectionStyle = .none
                cell.tableTitlelabel.text = "OO님, 이건어때요?"
                return cell
            default:
                return UITableViewCell()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ItemDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.contentListView.tableHeaderView as! ItemDetailTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView, pageControl: imageListpageControl)
        
        setNavigationColorByHeight(scrollView)
    }
}

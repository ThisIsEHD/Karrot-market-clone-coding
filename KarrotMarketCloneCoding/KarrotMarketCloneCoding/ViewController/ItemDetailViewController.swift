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
            itemDetailViewBottomStickyView.configure(price: item?.price)
            itemDetailViewContentsTableView.reloadData()
        }
    }
    /// 상세페이지의 이미지 컬렉션뷰
    private let itemImagesCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        cv.showsHorizontalScrollIndicator = false
        cv.register(ItemDetailViewImagesCollectionViewCell.self, forCellWithReuseIdentifier: "ItemDetailViewImagesCollectionViewCell")
        cv.isPagingEnabled = true
        
        return cv
    }()
    
    /// 이미지 컬렉션 뷰의 페이지컨트롤
    private lazy var itemImagesCollectionViewPageControl: UIPageControl = {
        
        let pc = UIPageControl()
        
        pc.numberOfPages = item?.images?.count ?? 1
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .systemGray5
        pc.currentPageIndicatorTintColor = .white
        
        return pc
    }()
    
    /// 상세페이지의 컨텐츠 테이블뷰
    private let itemDetailViewContentsTableView: UITableView = {
        
        let tv = UITableView()
        
        tv.register(ItemDetailViewProfileCell.self, forCellReuseIdentifier: "ItemDetailViewProfileCell")
        tv.register(ItemDetailViewDescriptionCell.self, forCellReuseIdentifier: "ItemDetailViewDescriptionCell")
        tv.register(ItemDetailViewOtherPostsCell.self, forCellReuseIdentifier: "ItemDetailViewOtherPostsCell")
        
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    /// 상세페이지의 테이블 헤더뷰
    private lazy var itemDetailTableHeaderView = UIView()
    
    /// 상태바 뷰
    let statusBarView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height))
    
    let gradient: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.locations = [0.0,1.0]
        gl.colors = [UIColor.lightGray.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        return gl
    }()
    
    /// 하단 고정 뷰
    private let itemDetailViewBottomStickyView = ItemDetailViewBottomStickyView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.shared.fetchItem(id: item!.id!) { [self] result in
            switch result {
                case .success(let item):
                    self.item = item
                case .failure:
                    print("서버에러")
            }
        }
        
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        setNavigation(itemDetailViewContentsTableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        statusBarView.backgroundColor = .systemBackground
        statusBarView.alpha = 1
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = .none
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        itemDetailViewContentsTableView.dataSource = self
        itemDetailViewContentsTableView.delegate = self
        
        itemDetailViewContentsTableView.tableHeaderView = itemDetailTableHeaderView
        
     
        if item?.images?.count != 0 {
            itemDetailViewContentsTableView.contentInsetAdjustmentBehavior = .never
            itemDetailTableHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
        } else {
            itemDetailViewContentsTableView.contentInsetAdjustmentBehavior = .automatic
            itemDetailTableHeaderView.frame = .zero
        }
        
        itemImagesCollectionView.dataSource = self
        itemImagesCollectionView.delegate = self
        
        itemDetailViewContentsTableView.addSubview(itemImagesCollectionView)
        itemDetailViewContentsTableView.addSubview(itemImagesCollectionViewPageControl)
        
        view.addSubview(itemDetailViewContentsTableView)
        view.addSubview(itemDetailViewBottomStickyView)
        
        statusBarView.backgroundColor = .systemBackground
        statusBarView.alpha = 0
        
        view.addSubview(statusBarView)
    }
    
    func setNavigation(_ sender: UIScrollView) {
        
        if sender.contentOffset.y >= 300 {
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.shadowImage = .none
            self.statusBarView.alpha = 1
        } else {
            if item?.images?.count == 0 {
                navigationController?.navigationBar.backgroundColor = .systemBackground
                navigationController?.navigationBar.tintColor = .black
                navigationController?.navigationBar.shadowImage = .none
                self.statusBarView.alpha = 1
            } else {
                navigationController?.navigationBar.backgroundColor = .clear
                navigationController?.navigationBar.tintColor = .white
                navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.statusBarView.alpha = 0
                
                gradient.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height)
                /// layer에 추가
                self.view.layer.addSublayer(gradient)
            }
        }
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        itemImagesCollectionView.anchor(top: itemDetailViewContentsTableView.tableHeaderView?.topAnchor, bottom: itemDetailViewContentsTableView.tableHeaderView?.bottomAnchor, leading: itemDetailViewContentsTableView.tableHeaderView?.leadingAnchor, trailing: itemDetailViewContentsTableView.tableHeaderView?.trailingAnchor)
        
        itemImagesCollectionViewPageControl.anchor(bottom: itemImagesCollectionView.bottomAnchor)
        itemImagesCollectionViewPageControl.centerX(inView: itemImagesCollectionView)
        
        itemDetailViewContentsTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, bottomConstant: 120, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        itemDetailViewBottomStickyView.anchor(bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 120)
    }
}


// MARK: - UICollectionViewDataSource

extension ItemDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailViewImagesCollectionViewCell", for: indexPath) as! ItemDetailViewImagesCollectionViewCell
        
        AF.request(item?.images?[indexPath.row].url ?? "").validate().validate(contentType: ["application/octet-stream"]).responseData { response in
            
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
        
        if item?.images?[indexPath.row] != nil {
            return collectionView.bounds.size
        } else {
            return CGSize(width: 0, height: 0)
        }
       
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
                cell.setProfile(nickname: item?.nickname, image: UIImage(named: "defaultProfileImage"))
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewDescriptionCell", for: indexPath) as! ItemDetailViewDescriptionCell
                cell.selectionStyle = .none
                cell.setDescription(itemName: item?.title ?? "", category: item?.categoryId ?? 0, content: item?.content ?? "", wishs: item?.wishes ?? 0, views: item?.views ?? 0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewOtherPostsCell", for: indexPath) as! ItemDetailViewOtherPostsCell
                cell.selectionStyle = .none
                if let nickname = item?.nickname {
                    cell.tableTitlelabel.text = "\(nickname)님의 판매 상품"
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewOtherPostsCell", for: indexPath) as! ItemDetailViewOtherPostsCell
                cell.selectionStyle = .none
                if let nickname = item?.nickname {
                    cell.tableTitlelabel.text = "\(nickname)님, 이건어때요?"
                }
              
                return cell
            default:
                return UITableViewCell()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ItemDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == itemImagesCollectionView {
            
            let width = scrollView.bounds.size.width
            let x = scrollView.contentOffset.x + (width/2.0)
            let newPage = Int(x / width)
            
            if itemImagesCollectionViewPageControl.currentPage != newPage {
                itemImagesCollectionViewPageControl.currentPage = newPage
            }
        } else {
            setNavigation(scrollView)
        }
    }
}

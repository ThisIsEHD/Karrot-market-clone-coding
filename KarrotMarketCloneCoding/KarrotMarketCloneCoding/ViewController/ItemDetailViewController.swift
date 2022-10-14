//
//  ItemDetailViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit
import Alamofire

class ItemDetailViewController: UIViewController, UITableViewDelegate, WishButtonDelegate {
    // MARK: - Properties
    
    private var productId: Int?
    var item: Item? {
        didSet {
            
            flag = true
            itemImagesCollectionView.reloadData()
            itemDetailViewBottomStickyView.configure(price: item?.price)
            itemImagesCollectionViewPageControl.numberOfPages = item?.images?.count ?? 1
            itemDetailViewContentsTableView.reloadData()
            itemDetailViewBottomStickyView.getWishButton().isSelected = item?.wished ?? false
            
            /// 사용자의 정보를 가져와 찜한 상품인지 확인
            /// wishButton 상태 업데이트
        }
    }
    var flag: Bool?
    
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
        
        pc.currentPage = 0
        pc.pageIndicatorTintColor = UIColor(white: 0.4, alpha: 0.4)
        pc.currentPageIndicatorTintColor = .white
        
        return pc
    }()
    
    /// 상세페이지의 컨텐츠 테이블뷰
    private let itemDetailViewContentsTableView: UITableView = {
        
        let tv = UITableView()
        
        tv.register(ItemDetailViewProfileCell.self, forCellReuseIdentifier: "ItemDetailViewProfileCell")
        tv.register(ItemDetailViewDescriptionCell.self, forCellReuseIdentifier: "ItemDetailViewDescriptionCell")
        tv.register(ItemDetailViewOtherItemsCell.self, forCellReuseIdentifier: "ItemDetailViewOtherPostsCell")
        
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
    
    convenience init(productId: Int?) {
        self.init()
    
        Network.shared.fetchItem(id: productId!) { [self] result in
            switch result {
                case .success(let item):
                    
                    self.item = item
                case .failure(let error):
                    /// 에러별 다른처리?
                    print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemDetailViewBottomStickyView.delegate = self
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
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
    
    // MARK: - Actions
   
    func addWishList() {
        
        guard let itemID = item?.id, let userID = item?.userId else { return }
        
        Network.shared.addWishItem(id: itemID, of: userID) { [unowned self] result in
            switch result {
                case .success:
                    itemDetailViewBottomStickyView.getWishButton().isSelected = true
                    return
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func deleteWishList() {
        
        guard let itemID = item?.id, let userID = item?.userId else { return }
        
        Network.shared.deleteWishItem(id: itemID, of: userID) { [unowned self] result in
            switch result {
                case .success:
                    itemDetailViewBottomStickyView.getWishButton().isSelected = false
                    return
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        itemDetailViewContentsTableView.dataSource = self
        itemDetailViewContentsTableView.delegate = self
        
        itemDetailViewContentsTableView.tableHeaderView = itemDetailTableHeaderView
        
        /// 이미지 백그라운드 다운로드 후 구성하기 위한 코드 작성하기
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [self] in
            if item?.images?.count != nil {
                itemDetailViewContentsTableView.contentInsetAdjustmentBehavior = .never
                itemDetailTableHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
                gradient.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height)
                
                view.layer.addSublayer(gradient)
            } else {
                itemDetailViewContentsTableView.contentInsetAdjustmentBehavior = .automatic
                itemDetailTableHeaderView.frame = .zero
            }
        }
        
        itemImagesCollectionView.dataSource = self
        itemImagesCollectionView.delegate = self
        
        itemDetailViewContentsTableView.addSubview(itemImagesCollectionView)
        itemDetailViewContentsTableView.addSubview(itemImagesCollectionViewPageControl)
        
        statusBarView.backgroundColor = .systemBackground
        statusBarView.alpha = 0
        
        view.addSubview(itemDetailViewContentsTableView)
        view.addSubview(itemDetailViewBottomStickyView)
        view.addSubview(statusBarView)
    }
    
    func setNavigation(_ sender: UITableView) {
        if sender.contentOffset.y >= 300 {
            
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.shadowImage = .none
            
            statusBarView.alpha = 1
            gradient.isHidden = true
        } else {
            if item?.images?.count == nil {
                
                navigationController?.navigationBar.backgroundColor = .systemBackground
                navigationController?.navigationBar.tintColor = .black
                navigationController?.navigationBar.shadowImage = .none
                
                statusBarView.alpha = 1
                gradient.isHidden = false
            } else {
                
                navigationController?.navigationBar.backgroundColor = .clear
                navigationController?.navigationBar.tintColor = .white
                navigationController?.navigationBar.shadowImage = UIImage()
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                
                statusBarView.alpha = 0
                gradient.isHidden = false
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
        
        guard let url = item?.images?[indexPath.row].url else {
            return ItemDetailViewImagesCollectionViewCell()
        }
        
        Network.shared.fetchImage(url: url) { result in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                case .failure(let error):
                    print(error)
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
                
                guard let url = item?.profileImage else {
                    cell.setProfile(nickname: item?.nickname, image: nil)
                    return cell }
                
                Network.shared.fetchImage(url: url) {[unowned self] result in
                    switch result {
                        case .success(let image):
                            cell.setProfile(nickname: item?.nickname, image: image)
                        case .failure(let error):
                            print(error)
                    }
                }
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewDescriptionCell", for: indexPath) as! ItemDetailViewDescriptionCell
                cell.selectionStyle = .none
                cell.setDescription(itemName: item?.title ?? "", category: item?.categoryId ?? 0, content: item?.content ?? "", wishs: item?.wishes ?? 0, views: item?.views ?? 0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewOtherPostsCell", for: indexPath) as! ItemDetailViewOtherItemsCell
                cell.selectionStyle = .none
                if let nickname = item?.nickname {
                    cell.tableTitlelabel.text = "\(nickname)님의 판매 상품"
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailViewOtherPostsCell", for: indexPath) as! ItemDetailViewOtherItemsCell
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
            if flag != nil {
                setNavigation(itemDetailViewContentsTableView)
            }
        }
    }
}

protocol WishButtonDelegate: AnyObject {
    func addWishList()
    func deleteWishList()
}

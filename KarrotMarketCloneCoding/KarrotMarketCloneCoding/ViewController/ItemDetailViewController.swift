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
            itemDetailViewContentsTableView.reloadData()
            
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "verticalDots"), style: .plain, target: self, action: #selector(showExtraWorks))
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        ehd: 🛑 현재는 iamges.count가 항상 0 이 아니라 nil 이 나옴. 네트워킹 속도가 뷰를 구성하는 속도보다 느려서 그런듯. 차후 skeleton view 등을 적용하며 네트워킹 이후에 뷰를 구성하도록 해서 iamges의 유무에 따라 navigationbar.backgroundcolor 와 tintcolor를 달리해야 함. 실제 당근에서 (라이트모드일때. 우리는 라이트만 하고있으니) 이미지가 없을 때는 navigationbar.backgroundcolor의 경우에는 white, 있을 때는 clear 이며 navigationbar.tintcolor의 경우에는 이미지 없을 때는 검(홈뷰컨에서의 색) -> 흰(네트워킹 이전) -> 검(네트워킹 이후) 이고, 이미지 있을 때는 검(홈뷰컨) -> 흰(네트워킹 이전, 이후) 이다. 참고로 당근에서는 백버튼만 디테일 뷰에 들어갈 때 상기의 틴트컬러에 변화에 따라 동적으로 아주빠르게 변경하며 표시하고 나머지 버튼들은 네트워킹이 끝난 후 최종 틴트컬러를 확정한 후 한꺼번에 띄운다.
//        if item?.images?.count != 0 {
//            print("📣📣")
//            print(item?.images?.count)
//            print(item?.images)
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//
            statusBarView.alpha = 0
//        } else {
//            print("📣")
//            print(item?.images?.count)
//            print(item?.images)
//
//            navigationController?.navigationBar.backgroundColor = .systemBackground
//            navigationController?.navigationBar.tintColor = .label
//            navigationController?.navigationBar.shadowImage = UIImage()
//            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        }
//
        gradient.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        statusBarView.backgroundColor = .white
        statusBarView.alpha = 1
//
//        navigationController?.navigationBar.backgroundColor = .systemBackground
//        navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.shadowImage = .none
        
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = .none
        gradient.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc private func showExtraWorks() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "게시글 수정", style: .default) { _ in
            
            let nextVC = NewPostTableViewController()
            let nav = UINavigationController(rootViewController: nextVC)
            
            nav.navigationBar.barTintColor = .label
            nav.modalPresentationStyle  = .fullScreen
            
            nextVC.doneButtonTapped = { [weak self] in
                
//                Put api 호출 및 해당 수정사항이 반영된 ItemDetailVC로 정보 변경
            }
            
            self.present(nav, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(modifyAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
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
        
        view.addSubview(itemDetailViewContentsTableView)
        view.addSubview(itemDetailViewBottomStickyView)
        view.addSubview(statusBarView)
    }
    
    func setNavigation(_ sender: UITableView) {
        if item?.images?.count != nil {
            if sender.contentOffset.y >= 300 {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance.backgroundColor = .systemBackground
                appearance.backgroundEffect = .none
                navigationController?.navigationBar.tintColor = .label
                self.navigationItem.standardAppearance = appearance
                self.navigationItem.scrollEdgeAppearance = appearance
                gradient.isHidden = true
            } else {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundEffect = .none
                appearance.shadowColor = .clear
                appearance.shadowImage = UIImage()
                navigationController?.navigationBar.tintColor = .systemBackground
                self.navigationItem.standardAppearance = appearance
                self.navigationItem.scrollEdgeAppearance = appearance
                gradient.isHidden = false
            }
        } else {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .systemBackground
            appearance.backgroundEffect = .none
    //                appearance.shadowColor = .clear
    //                appearance.shadowImage = UIImage()
            self.navigationItem.standardAppearance = appearance
            self.navigationItem.scrollEdgeAppearance = appearance
            gradient.isHidden = false
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

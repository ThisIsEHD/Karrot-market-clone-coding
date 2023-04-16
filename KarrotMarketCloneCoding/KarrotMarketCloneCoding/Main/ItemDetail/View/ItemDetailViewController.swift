//
//  ItemDetailViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit
import Combine
import Alamofire

class ItemDetailViewController: UIViewController, UITableViewDelegate, WishButtonDelegate {
    
    // MARK: - Properties
    
    enum SectionType: Int {
        case imageSection
        case descriptionSection
    }
    
    private let viewModel = ItemDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var productID: Int
    private var itemImages: [UIImage] = []
    
    private let itemDetailTableView: UITableView = {
        
        let tv = UITableView()
        
        tv.register(ItemDetailViewImagesCell.self, forCellReuseIdentifier: ItemDetailViewImagesCell.identifier)
        tv.register(ItemDetailViewProfileCell.self, forCellReuseIdentifier: ItemDetailViewProfileCell.identifier)
        tv.register(ItemDetailViewDescriptionCell.self, forCellReuseIdentifier: ItemDetailViewDescriptionCell.identifier)
        tv.register(ItemDetailViewOtherItemsCell.self, forCellReuseIdentifier: ItemDetailViewOtherItemsCell.identifier)
        
        tv.rowHeight = UITableView.automaticDimension
        tv.contentInsetAdjustmentBehavior = .never
        tv.separatorStyle = .none
        
        return tv
    }()
    
    /// 하단 고정 뷰
    private let itemDetailViewBottomStickyView = ItemDetailViewBottomStickyView()
    
    let scrollAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.red]
        return appearance
    }()
    
    let defaultAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear
        appearance.shadowImage = .none
        appearance.backgroundEffect = .none
        appearance.backgroundImage = .none
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        
        return appearance
    }()
    
    // MARK: - Life Cycle
    
    init(productID: Int) {
        self.productID = productID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$item
            .filter({ item in
                item != nil
            })
            .sink { [weak self] item in
                guard let item = item else { return }
                Task {
                    await self?.configure(with: item)
                    self?.itemDetailViewBottomStickyView.configure(price: item.price)
                    self?.itemDetailTableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        Task {
            let error = await viewModel.fetchItem(productID: productID)
            guard let error = error else { return }
            self.presentError(error: error)
        }
        
        navigationItem.scrollEdgeAppearance = defaultAppearance
        navigationItem.standardAppearance = scrollAppearance
        navigationItem.compactAppearance = scrollAppearance
        
        itemDetailViewBottomStickyView.delegate = self
//        setNavigation(itemDetailTableView)
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    func configure(with item: FetchedItemDetail) async {
        let imageURLs = item.imageUrls
        for imageURL in imageURLs {
            let result = await getImage(url: imageURL)
            switch result {
            case .success(let image):
                self.itemImages.append(image)
            case .failure(let error):
                self.presentError(error: error)
            }
        }
    }
    
    func addWishList() {
        
    }
    
    func deleteWishList() {
        
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        
        itemDetailTableView.dataSource = self
        itemDetailTableView.delegate = self
        
        view.addSubview(itemDetailTableView)
        view.addSubview(itemDetailViewBottomStickyView)
        
        itemDetailTableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        itemDetailViewBottomStickyView.anchor(top: itemDetailTableView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 120)
    }
    
    func setNavigation(_ sender: UITableView) {
        if sender.contentOffset.y >= UIScreen.main.bounds.width {
            
            navigationItem.scrollEdgeAppearance = defaultAppearance
            navigationItem.standardAppearance = scrollAppearance
            navigationItem.compactAppearance = scrollAppearance
        
        } else {
            if ((viewModel.item?.imageUrls.isEmpty) != nil) {
                
                navigationItem.scrollEdgeAppearance = defaultAppearance
                navigationItem.standardAppearance = defaultAppearance
                navigationItem.compactAppearance = defaultAppearance

            } else {
          
                navigationItem.scrollEdgeAppearance = defaultAppearance
                navigationItem.standardAppearance = scrollAppearance
                navigationItem.compactAppearance = scrollAppearance
                
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ItemDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.imageSection.rawValue {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case SectionType.imageSection.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailViewImagesCell.identifier, for: indexPath) as! ItemDetailViewImagesCell

            cell.images = self.itemImages
            
            return cell
            
        case SectionType.descriptionSection.rawValue:
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailViewProfileCell.identifier, for: indexPath) as! ItemDetailViewProfileCell
                cell.selectionStyle = .none
                
                if let item = viewModel.item {
                    let nickname = item.nickName
                    cell.setProfile(nickname: nickname, image: nil)
                }
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailViewDescriptionCell.identifier, for: indexPath) as! ItemDetailViewDescriptionCell
                cell.selectionStyle = .none
                
                if let item = viewModel.item {
                    cell.configure(with: item)
                }
                
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailViewOtherItemsCell.identifier, for: indexPath) as! ItemDetailViewOtherItemsCell
                cell.selectionStyle = .none
                if let nickname = viewModel.item?.nickName {
                    cell.titleLabel.text = "\(nickname)님의 판매 상품"
                }
                
                cell.delegate = self
                cell.items = viewModel.item?.postsFromSeller
                
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !itemImages.isEmpty {
            return UITableView.automaticDimension
        } else {
            if indexPath.section == SectionType.imageSection.rawValue {
                return 0
            } else {
                return UITableView.automaticDimension
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ItemDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == itemDetailTableView {
           setNavigation(itemDetailTableView)
        }
    }
}

protocol WishButtonDelegate: AnyObject {
    func addWishList()
    func deleteWishList()
}


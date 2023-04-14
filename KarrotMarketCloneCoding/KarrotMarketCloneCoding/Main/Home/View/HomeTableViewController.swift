//
// HomeTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit
import Alamofire

typealias DataSource = UITableViewDiffableDataSource<Section, FetchedItem>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>
typealias CellProvider = (UITableView, IndexPath, FetchedItem) -> UITableViewCell

final class HomeTableViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel = HomeTableViewModel()
    var isViewBusy = false
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    private var cellProvider: CellProvider = { (tableView, indexPath, item) in

        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell

        cell.item = item

        return cell
    }
    
    private let itemTableView : UITableView = {
        
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    private lazy var addPostButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let image = UIImage(named: "plusButton")
        
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 60 / 2
        btn.clipsToBounds = true
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)

        return btn
    }()
    
    // MARK: - Actions
    
    @objc func searchButtonDidTapped() {
        
        let searchVC = SearchViewController()
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func notiButtonDidTapped() {
        
        let notificationVC = NotificationViewController()
        
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func addButtonDidTapped() {
        
        let newPostVC = NewPostTableViewController()
        let nav = UINavigationController(rootViewController: newPostVC)
        
        nav.navigationBar.barTintColor = .label
        nav.modalPresentationStyle  = .fullScreen
        
        newPostVC.doneButtonTapped = { [weak self] in
            Task {
                guard let weakSelf = self else { return }

                weakSelf.viewModel.latestPage = nil
                
                await weakSelf.fetchItems()
            }
        }
        
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    
    private func configureAddButton() {
        view.addSubview(addPostButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        congifureViews()
        setupNavigationItems()
        setupTableView()
        
        Task {
            await fetchItems()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchItems), name: .updateItemList, object: nil)
        
        setConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc
    private func fetchItems() async {
        
        isViewBusy = true
        
        let result = await viewModel.fetchItems()
        
        switch result {
        case .success(let fetchedItemListData):
            var snapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>()
            
            snapshot.appendSections([Section.main])
            snapshot.appendItems(fetchedItemListData.content)
            
            await self.dataSource.apply(snapshot, animatingDifferences: true)
            self.isViewBusy = false
            
        case .failure(let error):
            print(error)
            SceneController.shared.logout()
        }
    }
    
    // MARK: - Setup
    
    private func setupNavigationItems() {
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTapped))
        let notiBarButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))
        
        searchBarButton.tintColor = .label
        notiBarButton.tintColor = .label
        
        navigationItem.rightBarButtonItems = [ searchBarButton, notiBarButton ]
    }
    
    private func setupTableView() {
        
        dataSource = UITableViewDiffableDataSource<Section, FetchedItem>(tableView: itemTableView, cellProvider: cellProvider)
        
        itemTableView.delegate = self
        itemTableView.dataSource = dataSource
//        itemTableView.prefetchDataSource = self
    }
    
    // MARK: - Configure UI
    
    private func congifureViews() {
        view.backgroundColor = .white
        view.addSubview(itemTableView)
        view.addSubview(addPostButton)
    }

    private func configureNavigationBar() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white
//        self.navigationItem.standardAppearance = appearance
//        self.navigationItem.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        addPostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

// MARK: - UITableViewDelegate

extension HomeTableViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !scrollView.frame.isEmpty && scrollView.contentOffset.y >= scrollView.frame.size.height {
            
            let contentHeight = scrollView.contentSize.height
            let yOffsetOfScrollView = scrollView.contentOffset.y
           
            let heightRemainFromBottom = contentHeight - yOffsetOfScrollView
            let frameHeight = scrollView.frame.size.height
            
            if heightRemainFromBottom < frameHeight, heightRemainFromBottom > 0, let fetchedItemCount = viewModel.fetchedItemCount, fetchedItemCount == 10 {
                Task {
                    await viewModel.fetchItems()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productId = dataSource.itemIdentifier(for: indexPath)?.id else { return }
        let nextVC = ItemDetailViewController(productId: productId)
        
        navigationController?.pushViewController(nextVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//extension HomeTableViewController: UITableViewDataSourcePrefetching {
    // prefetch 어떻게 하더라...
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            let imageURLs = indexPaths.compactMap { getImageURL(at: $0) }
//            imageURLs.forEach { url in
//                AF.download(url).responseData { response in
//                    guard let data = response.value else {
//                        return
//                    }
//                    let image = UIImage(data: data)
//                    DispatchQueue.main.async {
//                        let cell = tableView.cellForRow(at: indexPath) as? HomeTableViewCell
//                        cell?.thumbnailImageView.image = image
//                    }
//                }
//            }
//        }
//    }
//    func getImageURL(at indexPath: IndexPath) -> URL? {
//        let fetchedItemList = snapshot.itemIdentifiers(inSection: .main)
//        guard let stringURL = fetchedItemList[indexPath.row].imageURL else { return nil }
//        return URL(string: stringURL)
//    }
//}

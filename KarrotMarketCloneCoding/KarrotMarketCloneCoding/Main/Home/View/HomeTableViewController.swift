//
// HomeTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit
import Alamofire

typealias TableViewDataSource = UITableViewDiffableDataSource<Section, FetchedItem>
typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>
typealias TableViewCellProvider = (UITableView, IndexPath, FetchedItem) -> UITableViewCell

class HomeTableViewController: UIViewController {
    // MARK: - Properties
    
    var viewModel = HomeTableViewModel()
    var isViewBusy = false
    
    private var dataSource: TableViewDataSource!
    private var snapshot = TableViewSnapshot()
    private var cellProvider: TableViewCellProvider = { (tableView, indexPath, item) in

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
                
                weakSelf.fetchItems()
            }
        }
        
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureViews()
        setupNavigationItems()
        setupTableView()
        
        fetchItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchItems), name: .updateItemList, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc
    private func fetchItems() {
        isViewBusy = true
        
        Task {
            
            let result = await viewModel.fetchItems()
            
            switch result {
            case .success(let fetchedItemListData):
                var snapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>()
        
                snapshot.appendSections([Section.main])
                snapshot.appendItems(fetchedItemListData.content)
                
                await self.dataSource.apply(snapshot, animatingDifferences: true)
                
                self.isViewBusy = false
                
            case .failure(let error):
                switch error {
                case .unauthorized:
                    SceneController.shared.logout()
                default:
                    return presentError(error: error)
                }
            }
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
        
        dataSource = TableViewDataSource(tableView: itemTableView, cellProvider: cellProvider)
        
        itemTableView.delegate = self
        itemTableView.dataSource = dataSource
        itemTableView.backgroundColor = .white
    }
    
    // MARK: - Configure UI
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubview(itemTableView)
        view.addSubview(addPostButton)
        
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
        let nextVC = ItemDetailViewController(productID: productId)
        
        navigationController?.pushViewController(nextVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

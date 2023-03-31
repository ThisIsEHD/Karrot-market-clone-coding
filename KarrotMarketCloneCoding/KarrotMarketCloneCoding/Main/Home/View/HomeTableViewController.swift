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
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .medium))
        
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 60 / 2
        btn.clipsToBounds = true
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor.appColor(.carrot)
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

            guard let weakSelf = self else { return }
            
            weakSelf.viewModel.isViewBusy = false
            weakSelf.viewModel.latestPage = nil

            weakSelf.viewModel.fetchItems()
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
        
        viewModel.delegate = self
        viewModel.fetchItems()
        
        setConstraints()
    }
    
    func reloadTableViewData() {
        
//        viewModel.isViewBusy = false
//        viewModel.loadTestableData()
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
        addPostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 10, trailing: view.trailingAnchor, trailingConstant: 20)
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
                viewModel.fetchItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = UserDefaults.standard.object(forKey: Constant.userId) as? String ?? ""
        let productId = dataSource.itemIdentifier(for: indexPath)?.id
//        let nextVC = ItemDetailViewController(id: userId, productId: productId)
        
//        navigationController?.pushViewController(nextVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension HomeTableViewController: HomeTableViewModelDelegate {
    func applySnapshot(snapshot: Snapshot) {
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

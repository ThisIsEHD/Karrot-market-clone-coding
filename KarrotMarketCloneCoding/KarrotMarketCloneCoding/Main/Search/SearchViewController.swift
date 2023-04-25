//
//  SearchViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = HomeTableViewModel()
    
    private var dataSource: TableViewDataSource!
    private var snapshot = TableViewSnapshot()
    private var cellProvider: TableViewCellProvider = { (tableView, indexPath, item) in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
        
        cell.item = item
        
        return cell
    }
    
    var isViewBusy = true
    
    private lazy var searchBar: UISearchBar = {
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        
        searchBar.placeholder = "검색"
        
        return searchBar
    }()
    
    private lazy var navigationBottomView = SearchBarBottomView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width , height: 60))
    
    private let itemTableView : UITableView = {
        
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupTableView()
        configureViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationBottomView.removeFromSuperview()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    // MARK: - Configure Search View Controller
    
    private func setupSearchController() {
        navigationController?.navigationBar.addSubview(navigationBottomView)
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "검색"
        
        tabBarController?.tabBar.isHidden = true
        navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: searchBar)], animated: true)
        definesPresentationContext = false
    }
    
    // MARK: - DiffableDataSource
    
    func setupTableView() {
        
        dataSource = TableViewDataSource(tableView: itemTableView, cellProvider: cellProvider)
        
        itemTableView.delegate = self
        itemTableView.dataSource = dataSource
    }
    
    func reloadTableViewData(keyword: String?) {
        
        isViewBusy = true
        
        Task {
            
            let result = await viewModel.fetchItems(title: keyword)
            
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
    
    // MARK: - ConfigureViews
    
    
    private func configureViews() {
 
        view.addSubview(itemTableView)
        
        navigationBottomView.anchor(top: navigationController?.navigationBar.bottomAnchor, leading: navigationController?.navigationBar.leadingAnchor, trailing: navigationController?.navigationBar.trailingAnchor, height: 60)
        
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 60, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if !scrollView.frame.isEmpty && scrollView.contentOffset.y >= scrollView.frame.size.height {
            
            let contentHeight = scrollView.contentSize.height
            let yOffsetOfScrollView = scrollView.contentOffset.y
           
            let heightRemainFromBottom = contentHeight - yOffsetOfScrollView
            let frameHeight = scrollView.frame.size.height
            
            if heightRemainFromBottom < frameHeight, heightRemainFromBottom > 0, let fetchedItemCount = viewModel.fetchedItemCount, fetchedItemCount == 20 {
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


// MARK: - UISearchBarDelegate
    
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadTableViewData(keyword: searchBar.text)
    }
}

//
//  SearchViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

class SearchViewController: UIViewController {
    
// MARK: - Properties
    
    private var viewModel = HomeViewModel()
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    var isViewBusy = true
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        searchBar.placeholder = "검색"
        return searchBar
    }()
    
    private lazy var navigationBottomView = SearchBarBottomView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width , height: 60))
        
    private let itemTableView : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        tv.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureItemTableView()
        configureTableViewDiffableDataSource()
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationBottomView.removeFromSuperview()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    
    // MARK: - Configure Search View Controller
    private func configureSearchController() {
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
    
    func configureTableViewDiffableDataSource() {
        
        viewModel.dataSource = UITableViewDiffableDataSource(tableView: self.itemTableView, cellProvider: { tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
            
            cell.item = item
            return cell
        })
    }
    
    func reloadTableViewData(keyword: String?) {
        viewModel.isViewBusy = false
        viewModel.loadData(keyword: keyword) {
            self.itemTableView.reloadData()
        }
    }
    
    // MARK: - Configure TableView
    
    private func configureItemTableView() {
        itemTableView.delegate = self
        itemTableView.dataSource = viewModel.dataSource
        
        view.addSubview(itemTableView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        navigationBottomView.anchor(top: navigationController?.navigationBar.bottomAnchor, leading: navigationController?.navigationBar.leadingAnchor, trailing: navigationController?.navigationBar.trailingAnchor, height: 60)
        
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 60, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if !scrollView.frame.isEmpty, scrollView.contentOffset.y >= scrollView.frame.size.height {
          
            let contentHeight = scrollView.contentSize.height
            ///스크롤 하기전엔 0
            ///스크롤 하면서 증가

            let yOffset = scrollView.contentOffset.y
            ///스크롤 하기전엔 0
            ///스크롤 하면서 증가
            ///셀의 y 좌표

            let heightRemainFromBottom = contentHeight - yOffset

            let frameHeight = scrollView.frame.size.height
            
            if heightRemainFromBottom < frameHeight, viewModel.lastItemID != nil {
                
                viewModel.loadData(lastID: viewModel.lastItemID, keyword: searchBar.text)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ItemDetailViewController()
        
        vc.item = viewModel.dataSource?.itemIdentifier(for: indexPath)
        navigationController?.pushViewController(vc, animated: true)
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

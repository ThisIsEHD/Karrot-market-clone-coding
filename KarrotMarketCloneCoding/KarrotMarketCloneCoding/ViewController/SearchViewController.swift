//
//  SearchViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

class SearchViewController: UIViewController{
    
// MARK: - Properties
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        searchBar.placeholder = "검색"
        return searchBar
    }()
    
    private lazy var navigationBottomView = SearchBarBottomView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width , height: 60))
        
    private let ItemTableView : UITableView = {
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
    
    // MARK: - Configure TableView
    private func configureItemTableView() {
        ItemTableView.delegate = self
        ItemTableView.dataSource = self
               
        view.addSubview(ItemTableView)
    }
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        navigationBottomView.anchor(top: navigationController?.navigationBar.bottomAnchor, leading: navigationController?.navigationBar.leadingAnchor, trailing: navigationController?.navigationBar.trailingAnchor, height: 60)
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ItemDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UISearchBarDelegate
    
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

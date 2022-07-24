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
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationBottomView.removeFromSuperview()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    
    // MARK: - Configure Search View Controller
    func configureSearchController() {
        navigationController?.navigationBar.addSubview(navigationBottomView)
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "검색"
        tabBarController?.tabBar.isHidden = true
        navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: searchBar)], animated: true)
        definesPresentationContext = false
    }
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        navigationBottomView.anchor(top: navigationController?.navigationBar.bottomAnchor, leading: navigationController?.navigationBar.leadingAnchor, trailing: navigationController?.navigationBar.trailingAnchor, height: 60)
    }
}

// MARK: - UISearchBarDelegate
    
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

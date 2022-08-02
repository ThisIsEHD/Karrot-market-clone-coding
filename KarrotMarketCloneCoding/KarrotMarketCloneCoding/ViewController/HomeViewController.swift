//
// HomeViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit
import Alamofire

enum Section: Int, CaseIterable {
    case main
}

typealias DataSource = UITableViewDiffableDataSource<Section, Merchandise>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Merchandise>

final class HomeViewController: UIViewController {
    // MARK: - Properties
    var viewModel: HomeViewModel? {
        didSet {
            print("셀 구성하기")
        }
    }
    
    var dummy = [
        Merchandise(ownerId: 1, id: 2, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil),
        Merchandise(ownerId: 2, id: 4, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil),
        Merchandise(ownerId: 3, id: 4, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil)
    ]
    
    private let MerchandiseTableView : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(MerchandiseTableViewCell.self, forCellReuseIdentifier: "MerchandiseTableViewCell")
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    private lazy var addPostButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        btn.clipsToBounds = true
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.tintColor = UIColor.appColor(.carrot)
        btn.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)

        return btn
    }()
    
    private var dataSource: DataSource!
    private var sanpshot: Snapshot!
    
    
    // MARK: - Actions
    @objc func searchButtonDidTapped() {
        let searchVC = SearchViewController()
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func notiButtonDidTapped() {
    }
    
    @objc func addButtonDidTapped() {
        let newPostVC = NewPostTableViewController()
        newPostVC.modalPresentationStyle  = .fullScreen
        present(newPostVC, animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    private func configureAddButton() {
        view.addSubview(addPostButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationItems()
        configureMerchandiseTableView()
        configureTableViewDiffableDataSource()
        configureAddButton()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.barStyle = .default
//        navigationController?.navigationBar.backgroundColor = .systemBackground
//        navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.isTranslucent = false
    }
    // MARK: - DiffableDataSource
    
    func configureTableViewDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: self.MerchandiseTableView, cellProvider: { [weak self] tableView, indexPath, merchandise in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MerchandiseTableViewCell", for: indexPath) as! MerchandiseTableViewCell
            
            self?.viewModel?.loadImage(for: merchandise)
            cell.merchandise = merchandise
            
            return cell
        })
        viewModel?.loadData()
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Configure MerchandiseTableView
    private func configureMerchandiseTableView() {
        MerchandiseTableView.delegate = self
        MerchandiseTableView.dataSource = dataSource
        MerchandiseTableView.prefetchDataSource = self
               
        view.addSubview(MerchandiseTableView)
    }
    
    // MARK: - configure NavigationItems
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTapped)),
            UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))]
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        MerchandiseTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        addPostButton.anchor(bottom: view.bottomAnchor, bottomConstant: 100, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MerchandiseDetailViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(150.0)
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension HomeViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(#function)
        indexPaths.forEach { viewModel?.prefetchImage(at: $0)}
    }
}

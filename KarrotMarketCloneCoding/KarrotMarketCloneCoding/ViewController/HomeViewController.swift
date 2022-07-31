//
// HomeViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit
import Alamofire

final class HomeViewController: UIViewController {
    // MARK: - Properties
    var viewModel = HomeViewModel()
    var isViewBusy = true
    
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
    private var snapshot = Snapshot()
    
    // MARK: - Actions
    @objc func searchButtonDidTapped() {
        
        let searchVC = SearchViewController()
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func notiButtonDidTapped() {
<<<<<<< HEAD
//        var snapshot = dataSource.snapshot()
//        let items = [
//            Merchandise(ownerId: 4, id: 4, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil),
//            Merchandise(ownerId: 5, id: 4, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil),
//            Merchandise(ownerId: 6, id: 4, name: UUID().uuidString, imageUrl: nil, price: 10000, wishCount: nil, category: nil, views: nil, content: nil)
//        ]
//        dummy.append(contentsOf: items)
//        snapshot.appendItems(items)
//        dataSource.apply(snapshot)
        Network.shared.register(user: User(id: "domb@gmail.com", pw: "!Qwer1234", nickName: "sdsdsd", name: "돔브", phone: "010-1234-1234", profileImageUrl: nil))
=======

>>>>>>> c667028 (feat: network add httpgetJSON, JSONdecode)
    }
    
    @objc func addButtonDidTapped() {
        
        let newPostVC = NewPostTableViewController()
        
        newPostVC.modalPresentationStyle  = .fullScreen
        present(newPostVC, animated: true, completion: nil)
//        Network.shared.UserUpload(user: User(id: "sdsdsd", nickName: "sdsdsd", name: "sdsdsd", phone: "qweqwe", profileImageUrl: nil))
    }
    
    // MARK: - Life Cycle
    private func configureAddButton() {
        view.addSubview(addPostButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setupNavigationItems()
        configureMerchandiseTableView()
        configureTableViewDiffableDataSource()
        configureAddButton()
        reloadTableViewData()
        setConstraints()
    }
    // MARK: - DiffableDataSource
    
    func configureTableViewDiffableDataSource() {
        
        viewModel.dataSource = UITableViewDiffableDataSource(tableView: self.MerchandiseTableView, cellProvider: { tableView, indexPath, merchandise in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MerchandiseTableViewCell", for: indexPath) as! MerchandiseTableViewCell
            
            cell.merchandise = merchandise
            
            
            return cell
        })
    }
    
    func reloadTableViewData() {
        
<<<<<<< HEAD
        var snapshot = NSDiffableDataSourceSnapshot<Section, Merchandise>()
        snapshot.appendSections([.main])
//        snapshot.appendItems(dummy)
        self.dataSource.apply(snapshot, animatingDifferences: true)
        
=======
        viewModel.isViewBusy = false
        viewModel.loadData(lastID: viewModel.lastProductID)
>>>>>>> c667028 (feat: network add httpgetJSON, JSONdecode)
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Configure MerchandiseTableView
    private func configureMerchandiseTableView() {
        
        MerchandiseTableView.delegate = self
        MerchandiseTableView.dataSource = viewModel.dataSource
        MerchandiseTableView.prefetchDataSource = self
               
        view.addSubview(MerchandiseTableView)
    }
    
    // MARK: - Setup NavigationItems
    private func setupNavigationItems() {
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTapped))
        let notiBarButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))
        
        searchBarButton.tintColor = .label
        notiBarButton.tintColor = .label
        
        navigationItem.rightBarButtonItems = [ searchBarButton, notiBarButton ]
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        MerchandiseTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        addPostButton.anchor(bottom: view.bottomAnchor, bottomConstant: 100, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainFromBottom = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight {
            
            viewModel.loadData(lastID: viewModel
                                .lastProductID)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MerchandiseDetailViewController()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MerchandiseTableViewCell", for: indexPath) as? MerchandiseTableViewCell else { return }
        
        cell.merchandise = vc.merchandise
        
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
//        indexPaths.forEach { viewModel.prefetchImage(at: $0)}
    }
}



typealias DataSource = UITableViewDiffableDataSource<Section, Merchandise>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Merchandise>

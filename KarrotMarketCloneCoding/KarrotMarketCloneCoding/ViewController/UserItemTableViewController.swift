//
//  UserItemTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/05.
//

import UIKit

class UserItemTableViewController: UIViewController {
    // MARK: - Properties
    
    
    var viewModel = HomeViewModel()
    var isViewBusy = true
    private var userId: ID?
    private var navigationTitle: ListTitle?
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    private let itemTableView : UITableView = {
        
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    // MARK: - Life Cycle
    
    convenience init(userId: String?, navigationTitle: ListTitle?) {
        self.init()
        self.userId = userId
        self.navigationTitle = navigationTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        setupNavigation()
        configureItemTableView()
        configureTableViewDiffableDataSource()
        reloadTableViewData()
        
        setConstraints()
    }
    
    // MARK: - DiffableDataSource
    
    func configureTableViewDiffableDataSource() {
        
        viewModel.dataSource = UITableViewDiffableDataSource(tableView: self.itemTableView, cellProvider: { tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
            
            cell.item = item
            
            return cell
        })
    }
    
    func reloadTableViewData() {
        
        viewModel.isViewBusy = false
        switch navigationTitle {
            case .selling:
                viewModel.fetchUserSellingItems(userId: userId!, lastId: viewModel.lastItemID)
            case .buy:
                return
            case .wish:
                viewModel.fetchUserWishItems(userId: userId!, lastId: viewModel.lastItemID)
            case .none:
                return
        }
    }
    
    // MARK: - Configure UI
    
    private func configureItemTableView() {
        
        itemTableView.delegate = self
        itemTableView.dataSource = viewModel.dataSource
        view.addSubview(itemTableView)
    }
    
    private func configureNavigationBar() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white
//        self.navigationItem.standardAppearance = appearance
//        self.navigationItem.scrollEdgeAppearance = appearance
    }
        
    // MARK: - Setup NavigationItems
    
    private func setupNavigation() {
        navigationItem.title = navigationTitle?.rawValue
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

// MARK: - UITableViewDelegate

extension UserItemTableViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !scrollView.frame.isEmpty && scrollView.contentOffset.y >= scrollView.frame.size.height {
            
            let contentHeight = scrollView.contentSize.height
            ///스크롤 하기전엔 0
            ///스크롤 하면서 증가
            ///
            let yOffset = scrollView.contentOffset.y
            ///스크롤 하기전엔 0
            ///스크롤 하면서 증가
            ///셀의 y 좌표
            ///
            let heightRemainFromBottom = contentHeight - yOffset
            let frameHeight = scrollView.frame.size.height
            
            if heightRemainFromBottom < frameHeight, heightRemainFromBottom > 0, viewModel.lastItemID != nil {
                
                viewModel.loadData(lastID: viewModel.lastItemID)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = viewModel.dataSource?.itemIdentifier(for: indexPath)?.id
        let vc = ItemDetailViewController(productId: id)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
}

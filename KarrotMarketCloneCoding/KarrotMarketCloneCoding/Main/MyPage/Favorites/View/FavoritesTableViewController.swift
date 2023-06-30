//
//  ItemTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/05.
//

import UIKit

class FavoritesTableViewController: UIViewController {
    // MARK: - Properties

    var viewModel = FavoritesViewModel()
    
    private var dataSource: TableViewDataSource!
    private var snapshot = TableViewSnapshot()
    private var cellProvider: TableViewCellProvider = { (tableView, indexPath, item) in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseIdentifier, for: indexPath) as! FavoritesTableViewCell
        
        cell.item = item
        
        return cell
    }
    
    var isViewBusy = true
    
    private let itemTableView : UITableView = {
        
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.reuseIdentifier)
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        fetchFavoriteItems()
        configureViews()
    }
    
    // MARK: - DiffableDataSource
    
    func setupTableView() {
        
        dataSource = TableViewDataSource(tableView: itemTableView, cellProvider: cellProvider)
        
        itemTableView.delegate = self
        itemTableView.backgroundColor = .white
        itemTableView.dataSource = dataSource
    }
    
    func fetchFavoriteItems() {
        
        isViewBusy = true
        
        Task {
            
            let result = await viewModel.fetchFavoriteItems()
            
            switch result {
            case .success(let fetchedItemListData):
                var snapshot = TableViewSnapshot()
                
                let content = fetchedItemListData.content
                snapshot.appendSections([Section.main])
                snapshot.appendItems(content)
                
                await self.dataSource.apply(snapshot, animatingDifferences: true)
                self.isViewBusy = false
                
            case .failure(let error):
                switch error {
                case .unauthorized:
                    SceneController.shared.logout()
                case .unwrappingError:
                    return
                default:
                    return presentError(error: error)
                }
            }
        }
    }

    // MARK: - Configure Views
    
    private func configureViews() {
        
        title = "관심목록"
        view.addSubview(itemTableView)
        
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

// MARK: - UITableViewDelegate

extension FavoritesTableViewController: UITableViewDelegate {

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

//            if heightRemainFromBottom < frameHeight, heightRemainFromBottom > 0, viewModel.lastItemID != nil {
//
//                viewModel.loadData(lastID: viewModel.lastItemID)
//            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let userId = userId else { return }
//        let productId = viewModel.dataSource?.itemIdentifier(for: indexPath)?.id
//        let vc = ItemDetailViewController(id: userId, productId: productId)
//        navigationController?.pushViewController(vc, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 150
    }
}

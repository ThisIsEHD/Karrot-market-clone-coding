//
//  SalesItemCollectionViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 4/24/23.
//

import UIKit

protocol ItemFetchable: AnyObject {
    func fetchItem(isHide: Bool?, salesState: SalesState?) async -> Result<FetchedItemListData, KarrotError>
}

class SalesItemCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    weak var delegate: (ItemFetchable & ErrorPresentable)?
    
    var isViewBusy = true
    
    private var dataSource: TableViewDataSource!
    private var snapshot = TableViewSnapshot()
    private var cellProvider: TableViewCellProvider = { (tableView, indexPath, item) in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SalesItemTableViewCell.reuseIdentifier, for: indexPath) as! SalesItemTableViewCell
        
        cell.item = item
        
        return cell
    }
    
    private let itemTableView : UITableView = {
        
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(SalesItemTableViewCell.self, forCellReuseIdentifier: SalesItemTableViewCell.reuseIdentifier)
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(itemTableView)
        
        itemTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(contentView)
        }
        
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        
        dataSource = TableViewDataSource(tableView: itemTableView, cellProvider: cellProvider)
        
        itemTableView.delegate = self
        itemTableView.dataSource = dataSource
    }
    
    func fetchSellItems(isHide: Bool?, salesState: SalesState?) {
        
        isViewBusy = true
        
        Task {
            guard let delegate = delegate else { return }
            let result = await delegate.fetchItem(isHide: isHide, salesState: salesState)
            
            switch result {
            case .success(let fetchedItemListData):
                var snapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>()
                
                let content = fetchedItemListData.content
                snapshot.appendSections([Section.main])
                snapshot.appendItems(content)
                
                await self.dataSource.apply(snapshot, animatingDifferences: true)
                
                self.isViewBusy = false
                
            case .failure(let error):
                switch error {
                case .unauthorized:
                    SceneController.shared.logout()
                default:
                    return delegate.presentError(error: error)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension SalesItemCollectionViewCell: UITableViewDelegate {
    
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
        
        return 210
    }
}

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
    
    private let itemTableView : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    
    private lazy var addPostButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .medium))
        
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 60 / 2
        btn.clipsToBounds = true
        btn.setImage(image, for: .normal)
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
        
        view.backgroundColor = .systemBackground
        reloadTableViewData()
        configureNavigationItems()
        configureItemTableView()
        configureTableViewDiffableDataSource()
        configureAddButton()
        
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
        viewModel.loadData(lastID: viewModel.lastItemID)
    }
    
    // MARK: - Configure ItemTableView
    private func configureItemTableView() {
        itemTableView.delegate = self
        itemTableView.dataSource = viewModel.dataSource
        view.addSubview(itemTableView)
    }
    
    // MARK: - configure NavigationItems
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTapped)),
            UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))]
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
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
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
            
            viewModel.loadData(lastID: viewModel.lastItemID)
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

typealias DataSource = UITableViewDiffableDataSource<Section, Item>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

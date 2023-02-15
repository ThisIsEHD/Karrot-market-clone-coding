//
// HomeViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit
import Alamofire

typealias DataSource = UITableViewDiffableDataSource<Section, Item>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

final class HomeViewController: UIViewController {
    // MARK: - Properties
    
    var viewModel = HomeViewModel()
    var isViewBusy = true
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    private let itemTableView : UITableView = {
        
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    private lazy var addPostButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .medium))
        
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 60 / 2
        btn.clipsToBounds = true
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor.appColor(.carrot)
        btn.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)

        return btn
    }()
    
    // MARK: - Actions
    
    @objc func searchButtonDidTapped() {
        
        let searchVC = SearchViewController()
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func notiButtonDidTapped() {
        
        let notificationVC = NotificationViewController()
        
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func addButtonDidTapped() {
        
        let newPostVC = NewPostTableViewController()
        let nav = UINavigationController(rootViewController: newPostVC)
        
        nav.navigationBar.barTintColor = .label
        nav.modalPresentationStyle  = .fullScreen
        
        newPostVC.doneButtonTapped = { [weak self] in
            
            guard let weakSelf = self else { return }
            
            weakSelf.viewModel.isViewBusy = false
            weakSelf.viewModel.lastItemID = nil
            
            let job = { weakSelf.reloadTableViewData() }
            
            weakSelf.viewModel.loadData(lastID: weakSelf.viewModel.lastItemID, completion: job)
        }
        
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    
    private func configureAddButton() {
        view.addSubview(addPostButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        configureNavigationItems()
        configureItemTableView()
        configureTableViewDiffableDataSource()
        reloadTableViewData()
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
        
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        addPostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 10, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
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
        let userId = UserDefaults.standard.object(forKey: Const.userId) as? String ?? ""
        let productId = viewModel.dataSource?.itemIdentifier(for: indexPath)?.id
        let vc = ItemDetailViewController(id: userId, productId: productId)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
}

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
    
    private let merchandiseTableView : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        
        tv.register(MerchandiseTableViewCell.self, forCellReuseIdentifier: "MerchandiseTableViewCell")
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tv
    }()
    
    
    private lazy var addPostButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .medium))
        
        btn.layer.shadowRadius = 2
        btn.layer.shadowOpacity = 0.3
        btn.layer.cornerRadius = 50 / 2
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
//        let notificationVC = NotificationViewController()
//        navigationController?.pushViewController(notificationVC, animated: true)
        let merchandiseDetailVC = MerchandiseDetailViewController()
        navigationController?.pushViewController(merchandiseDetailVC, animated: true)
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
        print(#function)
        configureViews()
        configureNavigationItems()
        configureMerchandiseTableView()
        configureTableViewDiffableDataSource()
        configureAddButton()
        
        setConstraints()
    }
    
    // MARK: - DiffableDataSource
    
    func configureTableViewDiffableDataSource() {
        
        viewModel.dataSource = UITableViewDiffableDataSource(tableView: self.merchandiseTableView, cellProvider: { tableView, indexPath, merchandise in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MerchandiseTableViewCell", for: indexPath) as! MerchandiseTableViewCell
            
            cell.merchandise = merchandise
            
            return cell
        })
    }
    
    func reloadTableViewData() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Merchandise>()
//        snapshot.appendSections([.main])
////        snapshot.appendItems(dummy)
//        self.dataSource.apply(snapshot, animatingDifferences: true)

        viewModel.isViewBusy = false
        viewModel.loadData(lastID: viewModel.lastProductID)
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Configure MerchandiseTableView
    private func configureMerchandiseTableView() {
        
        merchandiseTableView.dataSource = viewModel.dataSource
               
        view.addSubview(merchandiseTableView)
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
        merchandiseTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
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

typealias DataSource = UITableViewDiffableDataSource<Section, Merchandise>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Merchandise>

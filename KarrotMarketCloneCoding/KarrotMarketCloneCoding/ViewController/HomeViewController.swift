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
    
    private let MerchandiseTableView : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        tv.register(MerchandiseTableViewCell.self, forCellReuseIdentifier: "MerchandiseTableViewCell")
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()

    // MARK: - Actions
    @objc func searchButtonDidTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func notiButtonDidTapped() {
        let notiVC = NotificationViewController()
        navigationController?.pushViewController(notiVC, animated: true)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupNavigationItems()
        configureMerchandiseTableView()
        setConstraints()
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Configure MerchandiseTableView
    private func configureMerchandiseTableView() {
        MerchandiseTableView.delegate = self
        MerchandiseTableView.dataSource = self
               
        view.addSubview(MerchandiseTableView)
    }
    
    // MARK: - Setup NavigationItems
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTapped)),
            UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))]
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        MerchandiseTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MerchandiseTableViewCell", for: indexPath) as! MerchandiseTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}

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

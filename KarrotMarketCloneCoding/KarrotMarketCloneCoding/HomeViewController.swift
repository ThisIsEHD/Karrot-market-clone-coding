//
// HomeViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Properties
    
    private let MerchandiseTable : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        tv.register(MerchandiseTableViewCell.self, forCellReuseIdentifier: "HomeCell")
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
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupNavigationItems()
        setMerchandiseTable()
        setConstraints()
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func setMerchandiseTable() {
        MerchandiseTable.delegate = self
        MerchandiseTable.dataSource = self
               
        view.addSubview(MerchandiseTable)
    }
    
    // MARK: - Setup NavigationItems
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTapped)),
            UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))]
    }
    
    // MARK: - Set Constraints
    private func setConstraints() {
        MerchandiseTable.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! MerchandiseTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MerchandiseDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
}

//
//  NotificationViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/23.
//

import UIKit

class NotificationViewController: UIViewController {
    
    var images = [UIImage(named: "logo"), UIImage(named: "logo"), UIImage(named: "logo"), UIImage(named: "logo"), UIImage(named: "logo")]
    var descriptions = ["아아아아", "어어어어어", "이이이이", "유유유유", "듀듀듀듀"]
    var dates = ["1", "2", "3", "4", "5"]
    let notificationTableView = NotificationTableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTableView.tableView.dataSource = self
        
        title = "알림"
        view.addSubview(notificationTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        setupNaviBar()
        setupTableViewLayout()
    }
    
    private func setupNaviBar() {

        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.left"), transitionMaskImage: nil)
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupTableViewLayout() {
        notificationTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier) as? NotificationTableViewCell {

            cell.imgView.image = images[indexPath.row]
            cell.desciptionLabel.text = descriptions[indexPath.row]
            cell.dateLabel.text = dates[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.performBatchUpdates {
                images.remove(at: indexPath.row)
                descriptions.remove(at: indexPath.row)
                dates.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
}

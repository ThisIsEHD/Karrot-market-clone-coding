//
//  SettingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/10/03.
//

import UIKit

final class SettingViewController: UITableViewController {
    private let titles = ["로그아웃", "회원탈퇴"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "설정"
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
    }
    
    private func showUserCheckVC() {
        let nav = UINavigationController(rootViewController: UserCheckViewController())
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: false, completion: nil)
    }
    
    private func withdraw() {
        Network.shared.deleteUser { error in
            switch error {
            case nil:
                let toHome = { self.tabBarController?.selectedIndex = 0 }
                Authentication.goHomeAndLogout(go: toHome)
            case .invalidToken:
                let completion:(UIAlertAction) -> () = { _ in
                    let toHome = { self.tabBarController?.selectedIndex = 0 }
                    Authentication.goHomeAndLogout(go: toHome)
                }
                let alert = SimpleAlert(message: "로그인 시간 만료. 다시 로그인해주세요.", completion: completion)
                self.present(alert, animated: true)
            default: break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if let id = UserDefaults.standard.object(forKey: Const.userId) as? String {
                KeyChain.delete(key: id)
                UserDefaults.standard.removeObject(forKey: Const.userId)
            }
            
            tabBarController?.selectedIndex = 0
            NotificationCenter.default.post(name: NotificationType.logout.name, object: nil)
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let job: (UIAlertAction) -> () = { _ in self.withdraw() }
            let alert = SimpleAlert(message: "정말 탈퇴하시겠어요?", completion: job)
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}

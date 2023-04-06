//
//  SettingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/10/03.
//

import UIKit

final class SettingViewController: UITableViewController {
    
    let settingViewModel = MyPageViewModel()
    
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
            SceneController.shared.logout()
//            쿠키문제로 로그아웃 api 호출시 실패
//            settingViewModel.logout { result in
//                switch result {
//                case .success:
//                    SceneController.shared.logout()
//                case .failure(let failure):
//                    print(failure)
//                }
//            }
           
        } else {
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            let completion: (UIAlertAction) -> () = { _ in
            }
            let alert = SimpleAlertController(message: "정말 탈퇴하시겠어요?", completion: completion)
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}

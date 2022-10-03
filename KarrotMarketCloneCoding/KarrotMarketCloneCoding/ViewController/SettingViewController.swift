//
//  SettingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/10/03.
//

import UIKit

final class SettingViewController: UITableViewController {
    let titles = ["로그아웃", "회원탈퇴"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "설정"
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
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
            print("로그아웃")
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            print("회원탈퇴")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

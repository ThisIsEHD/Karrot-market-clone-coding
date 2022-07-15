//
//  ProfileViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/15.
//

import UIKit

class ProfileViewController: UIViewController {
    
// MARK: - Properties
    
    private var user: User? {
        didSet {
            
        }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let myProfileTableList = [["내 동네 설정", "동네인증하기", "키워드 알림", "모아보기", "당근가계부", "관심 카테고리 설정"],
                                      ["동네생활 글/댓글", "동네홍보 글", "동네 가게 후기", "저장한 장소", "내 단골가게", "받은 쿠폰함"],
                                      ["비즈프로필 만들기", "광고"],
                                      ["친구초대", "공지사항", "자주 묻는 질문", "앱 설정"]]
    private let myProfileTableImageList = [["location", "target", "price-tag", "app", "book", "sliders"],
                                           ["writing", "file", "chat", "bookmark-white", "shop", "voucher"],
                                           ["shop", "speaker"],
                                           ["email", "microphone", "headphone", "setting"]]
    
    private lazy var profileView = ProfileTableHeaderView(width: self.view.bounds.width, height: 230)
    
// MARK: - Actions
 
// MARK: - LifeCycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        profileView.delegate = self
        
        view.addSubview(tableView)
        
        configureTableView()
    }
}

// MARK: - Configure UI
   
extension ProfileViewController {
    private func configureTableView() {
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(ProfileTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.separatorStyle = .none
        tableView.tableHeaderView = profileView
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

//MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 1:
                return "나의 활동"
            case 2:
                return "우리 동네"
            case 3:
                return "사장님 메뉴"
            case 4:
                return "기타"
            default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
//            case 0:
//                return 3
            case 1:
                return 6
            case 2:
                return 6
            case 3:
                return 2
            case 4:
                return 4
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "aCell") else { return UITableViewCell() }
//            cell.accessoryType = indexPath.row == 0 ? .disclosureIndicator : .none
//            return cell
//        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let targetImage = myProfileTableImageList[indexPath.section - 1][indexPath.row]
            let targetText = myProfileTableList[indexPath.section - 1][indexPath.row]
            cell.imageView?.image = UIImage(named: targetImage)
            cell.textLabel?.text = targetText
        return cell
//        }
    }
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")!
        let backgroundView = UIView(frame: header.bounds)
        backgroundView.backgroundColor = .systemBackground
        header.backgroundView = backgroundView
        header.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        header.textLabel?.textColor = .black
        return header
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == IndexPath(row: 1, section: 0) && indexPath == IndexPath(row: 2, section: 0) {
            return nil
        }
        return indexPath
    }
    
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        //첫번째 cell에만 효과 미적용
//        return indexPath.section != 0
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


extension ProfileViewController: ProfileViewDelegate {
    func goToMyProfile() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        present(vc, animated: true, completion: nil)
    }
}

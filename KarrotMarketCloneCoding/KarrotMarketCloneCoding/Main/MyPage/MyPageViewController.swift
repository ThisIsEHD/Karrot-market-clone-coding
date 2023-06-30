//
//  MyPageViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/15.
//

import UIKit
import Alamofire

final class MyPageViewController: UIViewController {
    // MARK: - Properties
    
    private var userId: ID = UserDefaults.standard.object(forKey: Constant.userId) as? String ?? ""
    private var userImage: UIImage?
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let myProfileTableList = [["내 동네 설정", "동네인증하기", "키워드 알림", "모아보기", "당근가계부", "관심 카테고리 설정"],
                                      ["동네생활 글/댓글", "동네홍보 글", "동네 가게 후기", "저장한 장소", "내 단골가게", "받은 쿠폰함"],
                                      ["비즈프로필 만들기", "광고"],
                                      ["친구초대", "공지사항", "자주 묻는 질문", "앱 설정"]]
    private let myProfileTableImageList = [["location", "aim", "price-tag", "apps", "book", "equalizer"],
                                           ["writing", "file", "messenger", "bookmark", "shop", "voucher"],
                                           ["shop", "megaphone"],
                                           ["email", "microphone", "support", "setting"]]
    private lazy var profileView = MyPageHeaderView(width: self.view.bounds.width, height: 135)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "나의 당근"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        return lbl
    }()
    
    // MARK: - Actions
    
    @objc func settingButtonDidTapped() {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.delegate = self
    
        setupNavigationItems()
        configureViews()
        setTableViewConstraints()
    }

    // MARK: - Setup NavigationItems
    
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(settingButtonDidTapped))
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(MyPageTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.separatorStyle = .none
        tableView.tableHeaderView = profileView
    }
    
    // MARK: - Setting TableView Constraints
    
    private func setTableViewConstraints() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

//MARK: - UITableViewDataSource

extension MyPageViewController: UITableViewDataSource {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let targetImage = myProfileTableImageList[indexPath.section - 1][indexPath.row]
        let targetText = myProfileTableList[indexPath.section - 1][indexPath.row]
        
        cell.imageView?.image = UIImage(named: targetImage)
        cell.textLabel?.text = targetText
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    
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
}


extension MyPageViewController: ProfileViewDelegate {
    func selectedItemTableVC(_ title: ItemList) {
        switch title {
        case .favorite:
            let nextVC = FavoritesTableViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        case .sales:
            let nextVC = SalesItemViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        case .purchase:
            break
        }
    }
}

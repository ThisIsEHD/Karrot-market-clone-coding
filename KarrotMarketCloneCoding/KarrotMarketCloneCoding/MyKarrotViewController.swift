//
//  MyKarrotViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/15.
//

import UIKit
import Alamofire

final class MyKarrotViewController: UIViewController {
    
// MARK: - Properties
    private var user: User? {
        return User(id: "kk@kk.com", nickName: "조각가", phone: "01038281234", name: "케이")
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
    
    private lazy var profileView = MyKarrotHeaderView(width: self.view.bounds.width, height: 230)
    
    private let titleLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "나의 당근"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        return lbl
    }()
    
// MARK: - Actions
 
// MARK: - LifeCycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "나의 당근"
//        navigationController.
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        profileView.delegate = self
        
        view.addSubview(tableView)
        
        configureTableView()
    }
}

// MARK: - Configure UI
   
extension MyKarrotViewController {
    private func configureTableView() {
        tableView.register(MyKarrotTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(MyKarrotTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
//        tableView.separatorStyle = .none
        tableView.tableHeaderView = profileView
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

//MARK: - UITableViewDataSource

extension MyKarrotViewController: UITableViewDataSource {
    
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
extension MyKarrotViewController: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIViewController()
        navigationController?.pushViewController(vc, animated: false)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension MyKarrotViewController: ProfileViewDelegate {
    
    func goToMyProfileVC() {
    }
    
    func goToDetailVC() {
    }
    
}

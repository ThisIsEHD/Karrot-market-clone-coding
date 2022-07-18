//
//  NewPostTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit

class NewPostTableViewController: UIViewController {
    
    let detailTextViewPlaceHolder = "게시글 내용을 작성해주세요. (가품 및 판매금지품목은 게시가 제한될 수 있어요.)"
    let navigationBar = CustomNavigationBar(navigationBarTitle: "중고거래 글쓰기", leftBarButtonImage: "xmark", rightBarButtonTitle: "완료", rightButtonColor: UIColor.appColor(.carrot))
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        
        tableView.register(PhotosSelectingTableViewCell.nib() , forCellReuseIdentifier: PhotosSelectingTableViewCell.identifier)
        tableView.register(TitleTableViewCell.nib(), forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.register(PriceTableViewCell.nib(), forCellReuseIdentifier: PriceTableViewCell.identifier)
        tableView.register(DetailTableViewCell.nib(), forCellReuseIdentifier: DetailTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        
        setNavigationBar()
        tableView.anchor(top: navigationBar.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setNavigationBar() {
        navigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 50)
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewPostTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 110
        } else if indexPath.row == 4 {
            
            return UITableView.automaticDimension
        } else {
            
            return 85
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosSelectingTableViewCell.identifier, for: indexPath) as! PhotosSelectingTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.row == 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath)
            
            cell.textLabel?.text = "카테고리 선택"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.identifier, for: indexPath) as! PriceTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 999)
            cell.selectionStyle = .none
            cell.descriptionTextView.delegate = self
            
            return cell
        }
    }
}

extension NewPostTableViewController: UITableViewDelegate {
    
}

extension NewPostTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == detailTextViewPlaceHolder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = detailTextViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
//        UIView.setAnimationsEnabled(true)
    }
}

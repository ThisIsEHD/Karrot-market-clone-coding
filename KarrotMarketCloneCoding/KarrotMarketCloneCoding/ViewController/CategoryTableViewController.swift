//
//  CategoryTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/22.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    let categories = ["디지털기기","생활가전","가구/인테리어","유아동","유아도서","생활/가공식품","스포츠/레저","여성잡화","여성의류","남성패션/잡화","게임/취미","뷰티/미용","반려동물용품","도서/티켓/음반","식물","기타 중고물품","삽니다"]
    var cellTapped: (CategoryTableViewController) -> () = { sender in }
    var selectedCategory = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        
        selectedCategory = cell?.textLabel?.text ?? ""
        cellTapped(self)
        navigationController?.popViewController(animated: true)
        
    }
}

class CategoryCell: UITableViewCell {
    
}

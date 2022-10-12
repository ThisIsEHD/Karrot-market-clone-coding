//
//  CategoryTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/22.
//

import UIKit

final class CategoryTableViewController: UITableViewController {
    
    var cellTapped: (Int) -> () = { _ in }
    var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Const.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = Const.categories[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        
        selectedCategory = cell?.textLabel?.text ?? ""
        cellTapped(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}

class CategoryCell: UITableViewCell {
    
}

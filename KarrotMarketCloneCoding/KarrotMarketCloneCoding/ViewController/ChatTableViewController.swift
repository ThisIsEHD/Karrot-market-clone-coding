//
//  ChatViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/24.
//

import UIKit

class ChatTableViewController: UIViewController {
    // MARK: - Properties
    
    let userId = UserDefaults.standard.object(forKey: Const.userId) as? String ?? ""
    
    var rooms: [Chatroom]? {
        didSet {
            chatListView.reloadData()
        }
    }
    
    let chatListView = UITableView()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureViews()
        configureChatList()
    }
    
    // MARK: - Actions
    
    private func configureChatList() {
        Network.shared.fetchChatrooms(id: userId) { result in
            switch result {
                case .success(let rooms):
                    self.rooms = rooms
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "채팅"
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(chatListView)
        chatListView.delegate = self
        chatListView.dataSource = self
        chatListView.rowHeight = 80
        chatListView.backgroundColor = .clear
        chatListView.tableFooterView = UIView(frame: .zero)
        chatListView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        
        chatListView.edge(inView: view)
    }
    
    // MARK: - Setting Constraints
    
    
}

extension ChatTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        guard let rooms = rooms?[indexPath.row] else { return ChatTableViewCell() }
        
        let buyer = rooms.buyer
        let seller = rooms.seller
        
        [buyer, seller].forEach { user in
            if user.userId == userId {
                cell.nicknameLabel.text = user.nickname
                cell.profileImageView.loadImage(url: user.profileImageUrl ?? "")
            }
        }
        
        cell.latestMessageLabel.text = rooms.lastChat.text
        cell.itemThumbnailImageView.loadImage(url: rooms.product.thumbnail ?? "")
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatroomId = rooms?[indexPath.row].chatroomId
        let conversationVC = ConversationViewController()
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}

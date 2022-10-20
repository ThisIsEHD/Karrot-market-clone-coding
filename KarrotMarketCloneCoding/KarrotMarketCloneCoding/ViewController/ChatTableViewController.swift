//
//  ChatViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/24.
//

import UIKit

class ChatTableViewController: UIViewController {
    // MARK: - Properties
    
    private var userId: ID = UserDefaults.standard.object(forKey: Const.userId) as? String ?? ""
    
    var rooms: [Chat]? {
        didSet {
            chatListView.reloadData()
        }
    }
    
    let chatListView = UITableView()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "채팅"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        return lbl
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rooms = [
            Chat(chatroomId: 1, productId: 1, product: nil, seller: User(chatroomId: 1, userId: "76fcfc43-5002-4d16-848f-525534c16e2", nickname: "domb", profileImageUrl: ""), buyer: User(chatroomId: 1, userId: "76fcfc43-5002-4d16-848f-525534ec16e2", nickname: "dodo", profileImageUrl: ""), lastChat: LastChat(text: "sdfsefsefsef", sendDate: Date())),
            Chat(chatroomId: 1, productId: 1, product: nil, seller: User(chatroomId: 2, userId: "76fcfc43-5002-4d16-848f-525534c16e2", nickname: "domb", profileImageUrl: ""), buyer: User(chatroomId: 1, userId: "76fcfc43-5002-4d16-848f-525534ec16e2", nickname: "dodo", profileImageUrl: ""), lastChat: LastChat(text: "sdfsefsefsef", sendDate: Date()))
        ]
        
        configureViews()
        //        fetchChatList()
    }
    
    // MARK: - Actions
    
    private func fetchChatList() {
        Network.shared.fetchAllChatrooms(id: userId) { result in
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        chatListView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        setupTableView()
        setConstraints()
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
    
    func setConstraints() {
        chatListView.edge(inView: view)
    }
    
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
            if user?.userId != userId {
                cell.nicknameLabel.text = user?.nickname
                cell.profileImageView.loadImage(url: user?.profileImageUrl ?? "")
                cell.latestMessageLabel.text = rooms.lastChat.text
//                cell.itemThumbnailImageView.loadImage(url: rooms.product?.thumbnail ?? "")
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let conversationVC = ConversationViewController()
        
        guard let rooms = rooms?[indexPath.row] else { return }
        let buyer = rooms.buyer
        let seller = rooms.seller
        
        [buyer, seller].forEach { user in
            if user?.userId != userId {

                Network.shared.fetchImage(url: user?.profileImageUrl ?? "") { result in
                    switch result {
                        case .success(let image):
                            conversationVC.man = ChatUser(id: user?.id, nickname: user?.nickname, profileImage: image)
                            self.navigationController?.pushViewController(conversationVC, animated: true)
                        case .failure(let error):
                            print(error)
                    }
                }
                
                conversationVC.man = ChatUser(id: user?.id, nickname: user?.nickname, profileImage: UIImage(named: "logo"))
                self.navigationController?.pushViewController(conversationVC, animated: true)
            }
        }
    }
}

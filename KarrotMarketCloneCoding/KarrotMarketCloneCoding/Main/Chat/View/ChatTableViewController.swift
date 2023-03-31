////
////  ChatViewController.swift
////  KarrotMarketCloneCoding
////
////  Created by 신동훈 on 2022/07/24.
////
//
//import UIKit
//
//class ChatTableViewController: UIViewController {
//    // MARK: - Properties
//    
//    private var userId: ID = UserDefaults.standard.object(forKey: Constant.userId) as? String ?? ""
//    
//    var rooms: [Chat]? {
//        didSet {
//            chatListView.reloadData()
//        }
//    }
//    
//    var lastId: Int?
//    var isFetchingChat = false
//    
//    let chatListView = UITableView()
//    
//    private let titleLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "채팅"
//        lbl.font = UIFont.boldSystemFont(ofSize: 20)
//        lbl.textColor = .black
//        return lbl
//    }()
//
//    // MARK: - Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configureViews()
//        //        fetchChatList()
//    }
//    
//    // MARK: - Actions
//    
//    private func fetchChatList() {
//        
//        isFetchingChat = true
//        
////        Network.shared.fetchAllChatrooms(id: userId, lastId: lastId) { result in
////            switch result {
////                case .success(let chatList):
////                    self.rooms?.append(contentsOf: chatList!)
////                    self.lastId = chatList?.last?.chatroomId
////                    self.isFetchingChat = false
////                case .failure(let error):
////                    print(error)
////            }
////        }
//    }
//    
//    // MARK: - Configure
//    
//    private func configureViews() {
//        view.backgroundColor = .systemBackground
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
//        chatListView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        
//        setupTableView()
//        setConstraints()
//    }
//    
//    private func setupTableView() {
//        view.addSubview(chatListView)
//        chatListView.delegate = self
//        chatListView.dataSource = self
//        chatListView.rowHeight = 80
//        chatListView.backgroundColor = .clear
//        chatListView.tableFooterView = UIView(frame: .zero)
//        chatListView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
//        
//        chatListView.edge(inView: view)
//    }
//    
//    // MARK: - Setting Constraints
//    
//    func setConstraints() {
//        chatListView.edge(inView: view)
//    }
//    
//}
//
//extension ChatTableViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return rooms?.count ?? 0
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
//        guard let rooms = rooms?[indexPath.row] else { return ChatTableViewCell() }
//        
//        let buyer = rooms.buyer
//        let seller = rooms.seller
//        
////        [buyer, seller].forEach { user in
////
////        }
//        
//        cell.selectionStyle = .none
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let conversationVC = ConversationViewController()
//        
//        guard let rooms = rooms?[indexPath.row] else { return }
//        let buyer = rooms.buyer
//        let seller = rooms.seller
//        
//        [buyer, seller].forEach { user in
////            if user?.userId != userId {
////
////                Network.shared.fetchImage(url: user?.profileImageUrl ?? "") { result in
////                    switch result {
////                        case .success(let image):
////                            conversationVC.man = ChatUser(id: user?.id, nickname: user?.nickname, profileImage: image)
////                            self.navigationController?.pushViewController(conversationVC, animated: true)
////                        case .failure(let error):
////                            print(error)
////                    }
////                }
////                
////                conversationVC.man = ChatUser(id: user?.id, nickname: user?.nickname, profileImage: UIImage(named: "logo"))
////                self.navigationController?.pushViewController(conversationVC, animated: true)
////            }
//        }
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let position = scrollView.contentOffset.y
//        
//        /// 이미지 prefetch와 캐시이미지 저장 구현하기
//    
//        if position > chatListView.contentSize.height - 1000 {
//            guard !isFetchingChat, rooms!.count >= 20, rooms!.count % 20 == 0 else { return }
//            
//            fetchChatList()
//        }
//    }
//}

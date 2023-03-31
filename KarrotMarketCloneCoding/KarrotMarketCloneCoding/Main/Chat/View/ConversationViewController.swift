////
////  ConversationViewController.swift
////  KarrotMarketCloneCoding
////
////  Created by 서동운 on 2022/10/14.
////
//
//import UIKit
//
//class ConversationViewController: UIViewController {
//    // MARK: - Properties
//    
////    var me = ChatUser(id: "76fcfc43-5002-4d16-848f-525534ec16e2", nickname: "domb", profileImage: UIImage())
////    var man: ChatUser?
//    
//    var chatroomId: Int? /// 해주는게 좋을진 모르겠음..
//    
////    lazy var messages: [Message] = {
////        return [
////                Message(user: me, body: "안녕하세요", sendDate: Date()),
////                Message(user: me, body: "구매할 수 있을까요?", sendDate: Date()),
////                Message(user: me, body: "ㅎㅎ", sendDate: Date()),
////
////                Message(user: man, body: "네 가능합니다.", sendDate: Date()),
////                Message(user: man, body: "내일까지 오실수 있나요?", sendDate: Date()),
////
////                Message(user: me, body: "네?", sendDate: Date()),
////                Message(user: me, body: "흠흠", sendDate: Date()),
////                Message(user: me, body: "다음주는 안될까요", sendDate: Date()),
////
////                Message(user: man, body: "안됩니다", sendDate: Date()),
////                Message(user: man, body: "내일오셔야돼요", sendDate: Date()),
////                Message(user: man, body: "ㅠㅜ", sendDate: Date())
////        ]
////    }()
//    
////    let style = ChatStyle()
//    
//    weak var delegate: UITableViewDelegate?
//    weak var dataSource: UITableViewDataSource?
//    
//    private let containerView = UIView()
//    private lazy var messageInputView = CustomInputView()
//    private lazy var conversationTableView = ConversationView()
//    
//    var containerViewBottomLayout: NSLayoutConstraint!
//    
//    // MARK: - Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .systemBackground
//        
//        messageInputView.style = style
//        
//        conversationTableView.delegate = self
//        conversationTableView.dataSource = self
//    
//        tabBarController?.tabBar.isHidden = true
//        
//        setupInputView()
//        
//        view.addSubview(containerView)
//        containerView.addSubview(conversationTableView)
//        containerView.addSubview(messageInputView)
//        
//        setconstraints()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//   
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        
//        self.conversationTableView.scrollToBottom(animated: true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        tabBarController?.tabBar.isHidden = false
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    // MARK: - Actions
//    
//    @objc open dynamic func keyboardWillShow(_ notification: Notification) {
//        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//        let keyboardHeight = keyboardFrame.cgRectValue.height
//        
//        containerViewBottomLayout.isActive = false
//        containerViewBottomLayout.constant = -keyboardHeight + view.safeAreaInsets.bottom
//        containerViewBottomLayout.isActive = true
//    
//        self.conversationTableView.scrollToBottom(animated: true)
//    }
//    
//    @objc open dynamic func keyboardWillHide(_ notification: Notification) {
//        
//        containerViewBottomLayout.isActive = false
//        containerViewBottomLayout.constant = 0
//        containerViewBottomLayout.isActive = true
//    }
//    
//    @objc func inputViewPrimaryActionTriggered() {
//        
////        let message = Message(user: me, body: messageInputView.message, sendDate: Date())
//       
//        insert(message)
//    }
//    
//    func insert(_ message: Message) {
//        
//        conversationTableView.performBatchUpdates {
//            
////            self.messages.append(message)
//            
//            let index = self.messages.count - 1
//            
//            self.conversationTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//        } completion: { _ in
//            self.conversationTableView.scrollToBottom(animated: true)
//        }
//    }
//    
//    // MARK: - Configure
//    
//    func setupInputView() {
//        
//        messageInputView.addTarget(self, action: #selector(inputViewPrimaryActionTriggered), for: .primaryActionTriggered)
//    }
//    
//    // MARK: - Setting Constraints
//    
//    func setconstraints() {
//        
//        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
//        containerViewBottomLayout = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
//        containerViewBottomLayout.isActive = true
//        conversationTableView.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: messageInputView.topAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: containerView.safeAreaLayoutGuide.trailingAnchor)
//        messageInputView.anchor(bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor)
//    }
//}
//
//
//
//// MARK: - UITableViewDataSource
//
//extension ConversationViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return messages.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let message = messages[indexPath.row]
//        
//        let identifier = message.user!.isMe ? "outgoingMessage" : "incomingMessage"
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ConversationViewCell
//        
//        guard indexPath.row - 1 >= 0 else {
//            cell.delegate = self
//            cell.message = message
//            cell.style = style
//            return cell
//        }
//        
//        let previousMessage = messages[indexPath.row - 1]
//        
//        if previousMessage.user?.id == message.user?.id {
//            cell.profileImageView?.isHidden = true
//        } else {
//            cell.profileImageView?.isHidden = false
//        }
//        
//        cell.delegate = self
//        cell.message = message
//        cell.style = style
//        
//        return cell
//    }
//}
//    
//// MARK: - Helpers
//
//extension UITableViewDelegate {
//    func profileImageTapped(user: ChatUser) { }
//}
//
//extension ConversationViewController: UITableViewDelegate {
//    
//    func message(for indexPath: IndexPath) -> Message {
//        return messages[indexPath.row]
//    }
//    
//    func profileImageTapped(user: ChatUser) {
//        print("이미지 누름")
//    }
//}

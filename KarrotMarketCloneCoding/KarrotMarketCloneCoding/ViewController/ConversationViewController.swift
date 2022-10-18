//
//  ConversationViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import UIKit

class ConversationViewController: UIViewController {
    // MARK: - Properties
    var me = ChatUser(id: "76fcfc43-5002-4d16-848f-525534ec16e2", nickname: "domb", profileImage: UIImage())
    var man: ChatUser?
    
    var chatroomId: Int? /// 해주는게 좋을진 모르겠음..
    var id = 11
    
    lazy var messages: [Message] = {
        return [
                Message(id: 1, user: me, body: "sejkflsjefsklefsefjkflselkfseffsdf", sendDate: Date()),
                Message(id: 2, user: me, body: "sdfsdfsdf", sendDate: Date()),
                Message(id: 3, user: me, body: "sdfsdsefsefsefseffsdf", sendDate: Date()),
         
                Message(id: 4, user: man, body: "sdfsawdalwkdmlawmdlamwldmlakwmdlmawlkdmlakmwldmlawmdlkamlwmddfsdf", sendDate: Date()),
                Message(id: 5, user: man, body: "sdfsleskfslekfsdfsdf", sendDate: Date()),
         
                Message(id: 6, user: me, body: "sdsefsefkjnselv8sesf3fsdfsdf", sendDate: Date()),
                Message(id: 7, user: me, body: "sdfsdfsdf", sendDate: Date()),
                Message(id: 8, user: me, body: "sdfsdsefsefjnsleffsdf", sendDate: Date()),
         
                Message(id: 9, user: man, body: "sdfsdvvfsdf", sendDate: Date()),
                Message(id: 10, user: man, body: "sdfsdfssevsevkjnslevdf", sendDate: Date()),
                Message(id: 11, user: man, body: "s", sendDate: Date())
        ]
    }()
    
    let style = ChatStyle()
    
    weak var delegate: UITableViewDelegate?
    weak var dataSource: UITableViewDataSource?
    
    var cachedSizes = [Int:CGSize]() /// 사이즈를 저장해서 사용
    
    private lazy var messageInputView = CustomInputView()
    private lazy var conversationView = ConversationView()
    private let containerView = UIView()
    
    var containerViewBottomLayout: NSLayoutConstraint!
        
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        messageInputView.style = style
        
        conversationView.delegate = self
        conversationView.dataSource = self
    
        tabBarController?.tabBar.isHidden = true
        
        setupInputView()
        
        view.addSubview(containerView)
        containerView.addSubview(conversationView)
        containerView.addSubview(messageInputView)
        
        setconstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        self.conversationView.scrollToBottom(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @objc open dynamic func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        containerViewBottomLayout.isActive = false
        containerViewBottomLayout.constant = -keyboardHeight + view.safeAreaInsets.bottom
        containerViewBottomLayout.isActive = true
    
        self.conversationView.scrollToBottom(animated: true)
    }
    
    @objc open dynamic func keyboardWillHide(_ notification: Notification) {
        
        containerViewBottomLayout.isActive = false
        containerViewBottomLayout.constant = 0
        containerViewBottomLayout.isActive = true
    }
    
    @objc func inputViewPrimaryActionTriggered() {
        id += 1
        
        let message = Message(id: id, user: me, body: messageInputView.message, sendDate: Date())
       
        insert(message)
    }
    
    func insert(_ message: Message) {
        
        conversationView.performBatchUpdates {
            
            self.messages.append(message)
            
            let itemIndex = self.messages.count - 1
            
            self.conversationView.insertRows(at: [IndexPath(row: itemIndex, section: 0)], with: .automatic)
        } completion: { _ in
            self.conversationView.scrollToBottom(animated: true)
        }
    }
    
    // MARK: - Configure
    
    func setupInputView() {
        
        messageInputView.addTarget(self, action: #selector(inputViewPrimaryActionTriggered), for: .primaryActionTriggered)
    }
    
    // MARK: - Setting Constraints
    
    func setconstraints() {
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        containerViewBottomLayout = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        containerViewBottomLayout.isActive = true
        conversationView.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: messageInputView.topAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: containerView.safeAreaLayoutGuide.trailingAnchor)
        messageInputView.anchor(bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor)
    }
}



// MARK: - UICollectionViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.item]
        
        let identifier = message.user!.isMe ? "outgoingMessage" : "incomingMessage"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ConversationViewCell
        
        guard indexPath.item - 1 >= 0 else {
            cell.delegate = self
            cell.message = message
            cell.style = style
            return cell
        }
        
        let previousMessage = messages[indexPath.item - 1]
        
        if previousMessage.user?.id == message.user?.id {
            cell.profileImageView?.isHidden = true
        } else {
            cell.profileImageView?.isHidden = false
        }
        
        cell.delegate = self
        cell.message = message
        cell.style = style
        
        return cell
    }
}
    
// MARK: - Helpers

extension UITableViewDelegate {
    func profileImageTapped(user: ChatUser) { }
}

extension ConversationViewController: UITableViewDelegate {
    
    func message(for indexPath: IndexPath) -> Message {
        return messages[indexPath.item]
    }
    
    func profileImageTapped(user: ChatUser) {
        print("이미지 누름")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching

extension ConversationViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            let message = message(for: indexPath)
//            calculateSize(for: message)
//        }
    }
    
//    @discardableResult
//    func calculateSize(for message: Message) -> CGSize {
//
//        if let size = cachedSizes[message.id] {
//            return size
//        }
//
//        let size = style.size(for: message, in: conversationView)
//        cachedSizes[message.id] = size
//
//        return size
//    }
}

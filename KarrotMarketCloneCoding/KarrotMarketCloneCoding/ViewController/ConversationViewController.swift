//
//  ConversationViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import UIKit

class ConversationViewController: UIViewController {
    // MARK: - Properties
    let me = ChatUser(id: "76fcfc43-5002-4d16-848f-525534ec16e2", nickname: "domb", profileImage: UIImage())
    
    let man = ChatUser(id: "kong", nickname: "go", profileImage: UIImage())
    
    var chatroomId: Int?
    var id = 0
    
    lazy var messages: [Message] = {
        return [
                Message(id: 1, user: me, body: "sdfsdseflsejkflselkfseffsdf", sendDate: Date()),
                Message(id: 1, user: me, body: "sdfsdfsdf", sendDate: Date()),
                Message(id: 1, user: me, body: "sdfsdsefsefsefseffsdf", sendDate: Date()),
         
                Message(id: 1, user: man, body: "sdfsdfsdf", sendDate: Date()),
                Message(id: 1, user: man, body: "sdfsleskfslekfsdfsdf", sendDate: Date()),
         
                Message(id: 1, user: me, body: "sdsefsefkjnselv8sesf3fsdfsdf", sendDate: Date()),
                Message(id: 1, user: me, body: "sdfsdfsdf", sendDate: Date()),
                Message(id: 1, user: me, body: "sdfsdsefsefjnsleffsdf", sendDate: Date()),
         
                Message(id: 1, user: man, body: "sdfsdvvfsdf", sendDate: Date()),
                Message(id: 1, user: man, body: "sdfsdfssevsevkjnslevdf", sendDate: Date()),
                Message(id: 1, user: man, body: "s", sendDate: Date())
        ]
    }()
    
    let style = ChatStyle()
    
    weak var delegate: UICollectionViewDelegate?
    weak var dataSource: UICollectionViewDataSource?
    
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
        conversationView.style = style
        
        conversationView.delegate = self
        conversationView.dataSource = self
    
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
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
                self.conversationView.insertItems(at: [IndexPath(item: itemIndex, section: 0)])
        } completion: { _ in
            self.conversationView.scrollToBottom(animated: true)
        }
    }
    
    func scrollToLastCell() {

        if messages.count > 0 {
            let itemIndex = IndexPath(item: messages.count-1, section: 0)
            self.conversationView.scrollToItem(at: itemIndex, at: .bottom, animated: true)
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

extension ConversationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = messages[indexPath.item]
        
        let identifier = message.user.isMe ? "outgoingMessage" : "incomingMessage"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ConversationViewCell
        
        guard indexPath.item-1 >= 0  else {
            cell.delegate = self
            cell.message = message
            cell.style = style
            return cell
        }

        let previousMessage = messages[indexPath.item-1]
        if previousMessage.user.id == message.user.id {
            cell.profileImageView?.isHidden = true
        } else {
            cell.profileImageView?.isHidden = false
        }
        print(indexPath.row, previousMessage.user.id.first!, message.user.id.first!, cell.profileImageView?.isHidden)
        cell.delegate = self
        cell.message = message
        cell.style = style
        
        return cell
    }
}
    
// MARK: - Helpers

extension UICollectionViewDelegate {
    func profileImageTapped(user: ChatUser) { }
}

extension ConversationViewController: UICollectionViewDelegate {
    
    func message(for indexPath: IndexPath) -> Message {
        return messages[indexPath.item]
    }
    
    func profileImageTapped(user: ChatUser) {
        print("이미지 누름")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching

extension ConversationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = message(for: indexPath)
        
        return calculateSize(for: message)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

//        for indexPath in indexPaths {
//            let message = message(for: indexPath)
//            calculateSize(for: message)
//        }
    }
    
    @discardableResult
    func calculateSize(for message: Message) -> CGSize {
        
        if let size = cachedSizes[message.id] {
            return size
        }
        
        let size = style.size(for: message, in: conversationView)
        
        cachedSizes[message.id] = size
        
        return size
    }
}

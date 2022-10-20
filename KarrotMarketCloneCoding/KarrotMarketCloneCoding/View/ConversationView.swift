//
//  ConversationView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/15.
//

import UIKit


class ConversationView: UITableView {
    
    required init() {
        super.init(frame: .zero, style: .plain)
        
        backgroundColor = .systemBackground
        
        alwaysBounceVertical = true
        keyboardDismissMode = .interactive
        separatorStyle = .none
        
        registerCells()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }
    
    func registerCells() {
        register(UINib(nibName: "OutgoingMessageCell", bundle: nil), forCellReuseIdentifier: "outgoingMessage")
        register(UINib(nibName: "IncomingMessageCell", bundle: nil), forCellReuseIdentifier: "incomingMessage")
    }
    
    public func scrollToBottom(animated: Bool) {
        guard contentSize.height > bounds.size.height else { return }
        setContentOffset(CGPoint(x: 0, y: (contentSize.height - bounds.size.height) + (contentInset.bottom)), animated: animated)
    }
}


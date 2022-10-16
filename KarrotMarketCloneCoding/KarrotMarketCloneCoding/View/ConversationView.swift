//
//  ConversationView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/15.
//

import UIKit


class ConversationView: UICollectionView {
    
    var style: ChatStyle? {
        didSet {
            backgroundColor = style?.backgroundColor
        }
    }
    
    required init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        alwaysBounceVertical = true
        keyboardDismissMode = .interactive
        registerCells()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }
    
    func registerCells() {
        register(UINib(nibName: "OutgoingMessageCell", bundle: nil), forCellWithReuseIdentifier: "outgoingMessage")
        register(UINib(nibName: "IncomingMessageCell", bundle: nil), forCellWithReuseIdentifier: "incomingMessage")
    }
    
    public func scrollToBottom(animated: Bool) {
        guard contentSize.height > bounds.size.height else { return }
        setContentOffset(CGPoint(x: 0, y: (contentSize.height - bounds.size.height) + (contentInset.bottom)), animated: animated)
    }
}


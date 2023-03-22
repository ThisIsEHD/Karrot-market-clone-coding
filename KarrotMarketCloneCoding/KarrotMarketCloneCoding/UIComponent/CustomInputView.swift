//
//  CustomInputView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import UIKit

class CustomInputView: UIControl, PlaceholderTextViewDelegate {
    // MARK: - Properties
  
    private(set) var message = ""

    /// The text in the textView
    private var text: String! {
        return textView.text
    }
    
    var textView = CustomPlaceholderTextView()
    
    lazy var plusButton = UIButton()
    lazy var sendButton = UIButton()
    
    var heightConstraint: NSLayoutConstraint!
    
    var maxHeight: CGFloat = 100
    
    var style: ChatStyle? {
        didSet {
            guard let style = style else { return }
            
            textView.style = style
            backgroundColor = style.inputViewBackgroundColor
            sendButton.tintColor = style.sendButtonTintColor
        }
    }
    
    // MARK: - Life Cycle
    
    required init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions

    @objc func sendButtonTapped(_ sender: UIButton) {
        message = textView.text
        textView.text = ""
        sendActions(for: .primaryActionTriggered)
    }
    
    @discardableResult open override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    @discardableResult open override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.text != ""
        sendButton.tintColor = textView.text != "" ? .appColor(.carrot) : style?.sendButtonTintColor
        let size = textView.sizeThatFits(CGSize(width: textView.bounds.size.width, height: .infinity))
        let height = size.height

        heightConstraint.constant = height < maxHeight ? height : maxHeight

        sendActions(for: .valueChanged)
    }
    
    // MARK: - Configure
    
    open func setup() {
        setupPlusButton()
        setupTextView()
        setupSendButton()
        setConstraints()
    }
    
    private func setupPlusButton() {
        self.addSubview(plusButton)
        
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.contentHorizontalAlignment = .fill
        plusButton.contentVerticalAlignment = .fill
        plusButton.tintColor = .systemGray
    }

    private func setupTextView() {
        self.addSubview(textView)
        
        textView.tintColor = .systemGray2
        textView.delegate = self
    }
    
    private func setupSendButton() {
        self.addSubview(sendButton)
        
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.isEnabled = false
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        plusButton.centerY(inView: self)
        plusButton.anchor(leading: safeAreaLayoutGuide.leadingAnchor, leadingConstant: 15, width: 28, height: 28)
        textView.anchor(top: topAnchor, topConstant: 2, bottom: bottomAnchor, bottomConstant: 2, leading: plusButton.trailingAnchor, leadingConstant: 15, trailing: sendButton.leadingAnchor, trailingConstant: 10)
        heightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.isActive = true
        sendButton.centerY(inView: self)
        sendButton.anchor(trailing: trailingAnchor, trailingConstant: 15, width: 28, height: 28)
    }
}

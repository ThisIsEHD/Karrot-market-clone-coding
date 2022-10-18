//
//  UserInterfaceObjects.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        keyboardAppearance = .dark
        leftViewMode = .always
        leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 5, height: 5)))
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 10
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.systemGray])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class CustomNavigationBar: UINavigationBar {
    
    init(navigationBarTitle: String? = nil, leftBarButtonTitle: String? = nil,leftBarButtonImage: String? = nil, leftButtonColor: UIColor = .label, rightBarButtonTitle: String? = nil, rightBarButtonImage: String? = nil, rightButtonColor: UIColor = .label, lefeButtonAction: Selector?, rightButtonAction: Selector?) {
        super.init(frame: .zero)
        
        let navigationItems = UINavigationItem(title: "")
        
        barTintColor = .systemBackground
        
        lazy var textLeftBarButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        lazy var imageLeftBarButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        
        lazy var textRightBarButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        lazy var imageRightBarButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        
        if let navigationBarTitle = navigationBarTitle {
            navigationItems.title = navigationBarTitle
        }
        
        if let leftBarButtonTitle = leftBarButtonTitle {
            
            textLeftBarButton.title = leftBarButtonTitle
            textLeftBarButton.tintColor = leftButtonColor
            textLeftBarButton.action = lefeButtonAction
            
            navigationItems.leftBarButtonItem = textLeftBarButton
        }
        
        if let leftBarButtonImage = leftBarButtonImage {
            
            imageLeftBarButton.image = UIImage(systemName: "\(leftBarButtonImage)")
            imageLeftBarButton.tintColor = leftButtonColor
            imageLeftBarButton.action = lefeButtonAction
            
            navigationItems.leftBarButtonItem = imageLeftBarButton
        }
        
        if let rightBarButtonTitle = rightBarButtonTitle {
            
            textRightBarButton.title = rightBarButtonTitle
            textRightBarButton.tintColor = rightButtonColor
            textRightBarButton.action = rightButtonAction
            
            navigationItems.rightBarButtonItem = textRightBarButton
        }
        
        if let rightBarButtonImage = rightBarButtonImage {
            
            imageRightBarButton.image = UIImage(systemName: "\(rightBarButtonImage)")
            imageRightBarButton.tintColor = rightButtonColor
            imageRightBarButton.action = rightButtonAction
            
            navigationItems.rightBarButtonItem = imageRightBarButton
        }
        
        
        setItems([navigationItems], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 채팅방 하단 메세지 입력창
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

// MARK: - PlaceholderTextViewDelegate
protocol PlaceholderTextViewDelegate: NSObjectProtocol {
   
   func textViewDidChange(_ textView: UITextView)
}

// MARK: - CustomPlaceholderTextView

class CustomPlaceholderTextView: UIView, UITextViewDelegate {
    // MARK: - Properties
    
    weak var delegate: PlaceholderTextViewDelegate?
    
    private let textView = UITextView()
    private let label = UILabel()
    
    var style: ChatStyle? {
        didSet {
            guard let style = style else { return }
            label.text = style.inputViewPlaceholder
            label.font = style.font
            label.textColor = style.inputPlaceholderTextColor
            
            textView.font = style.inputViewFont
            textView.textColor = style.inputViewTextColor
            textView.backgroundColor = .clear
            textView.tintColor = style.inputTextViewTintColor
            
            textView.textContainerInset = style.inputViewTextContainerInset
            
            backgroundColor = style.inputTextViewBackgroundColor
        }
    }
    
    var text: String! {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            textViewDidChange(textView)
        }
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    // MARK: - Actions
    
    func getTextView() -> UITextView {
        return textView
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(textView)
        label.isHidden = textView.text != ""
    }
    
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    // MARK: - Configure
    
    private func setup() {
        addSubviews()
      
        textView.delegate = self
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(label)
        addSubview(textView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        label.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 12, trailing: trailingAnchor)
        textView.anchor(top: topAnchor, topConstant: 8, bottom: bottomAnchor, bottomConstant: 8, leading: leadingAnchor, leadingConstant: 10, trailing: trailingAnchor)
    }
}

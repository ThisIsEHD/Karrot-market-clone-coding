////
////  CustomPlaceholderTextView.swift
////  KarrotMarketCloneCoding
////
////  Created by 서동운 on 3/22/23.
////
//
//import UIKit
//
//protocol PlaceholderTextViewDelegate: NSObjectProtocol {
//   
//   func textViewDidChange(_ textView: UITextView)
//}
//
//final class CustomPlaceholderTextView: UIView, UITextViewDelegate {
//    
//    // MARK: - Properties
//    
//    weak var delegate: PlaceholderTextViewDelegate?
//    
//    private let textView = UITextView()
//    private let label = UILabel()
//    
//    var text: String! {
//        get {
//            return textView.text
//        }
//        set {
//            textView.text = newValue
//            textViewDidChange(textView)
//        }
//    }
//    
//    // MARK: - Life Cycle
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    convenience init() {
//        self.init(frame: .zero)
//        setup()
//    }
//    
//    // MARK: - Actions
//    
//    func getTextView() -> UITextView {
//        return textView
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        delegate?.textViewDidChange(textView)
//        label.isHidden = textView.text != ""
//    }
//    
//    override func resignFirstResponder() -> Bool {
//        return textView.resignFirstResponder()
//    }
//    
//    override func becomeFirstResponder() -> Bool {
//        return textView.becomeFirstResponder()
//    }
//    
//    // MARK: - Configure
//    
//    private func setup() {
//        addSubviews()
//      
//        textView.delegate = self
//        self.layer.cornerRadius = 20
//        self.clipsToBounds = true
//        
//        setConstraints()
//    }
//    
//    private func addSubviews() {
//        addSubview(label)
//        addSubview(textView)
//    }
//    
//    // MARK: - Setting Constraints
//    
//    private func setConstraints() {
//        label.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 12, trailing: trailingAnchor)
//        textView.anchor(top: topAnchor, topConstant: 8, bottom: bottomAnchor, bottomConstant: 8, leading: leadingAnchor, leadingConstant: 10, trailing: trailingAnchor)
//    }
//}

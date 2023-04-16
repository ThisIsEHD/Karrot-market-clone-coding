//
//  ContentTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/18.
//

import UIKit

final class ContentTableViewCell: UITableViewCell {

    static let identifier = "ContentTableViewCell"
    internal var textChanged: (String?) -> Void = { _ in }
    
    private let textViewPlaceHolder = "게시글 내용을 작성해주세요."
    let contentTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentTextView.delegate = self
        contentTextView.font = .systemFont(ofSize: 18)
        contentTextView.text = textViewPlaceHolder
        contentTextView.textColor = .systemGray
        contentTextView.isScrollEnabled = true
        contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
        
        contentView.addSubview(contentTextView)
        
        contentTextView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 20))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ContentTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        } else {
            textChanged(textView.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.isEmpty {
            return true
        }
        
        if textView.frame.size.height > 300 {
            return false
        } else {
            return true
        }
    }
}

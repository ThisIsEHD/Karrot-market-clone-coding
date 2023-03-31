//
//  ContentTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/18.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func updateTextViewHeight(_ cell: ContentTableViewCell, _ textView: UITextView)
}

final class ContentTableViewCell: UITableViewCell {

    static let identifier = "ContentTableViewCell"
    internal var textChanged: (String?) -> Void = { _ in }
    weak var delegate: TableViewCellDelegate?
    
    private let textViewPlaceHolder = "게시글 내용을 작성해주세요."
    let contentTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentTextView.delegate = self
        contentTextView.font = .systemFont(ofSize: 18)
        contentTextView.text = textViewPlaceHolder
        contentTextView.textColor = .systemGray
        contentTextView.isScrollEnabled = false
    
        
        contentView.addSubview(contentTextView)
        
        contentTextView.anchor(top: contentView.topAnchor, topConstant: 10, bottom: contentView.bottomAnchor, bottomConstant: 10, leading: contentView.leadingAnchor, leadingConstant: 20, trailing: contentView.trailingAnchor, trailingConstant: 20)
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
    
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.updateTextViewHeight(self, textView)
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

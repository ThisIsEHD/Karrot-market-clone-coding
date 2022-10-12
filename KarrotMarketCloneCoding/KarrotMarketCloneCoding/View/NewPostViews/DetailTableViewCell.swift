//
//  DetailTableViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/18.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {

    static let identifier = "DetailTableViewCell"
    internal var textChanged: ((String)?) -> Void = { _ in }
    internal var content: String? {
        didSet {
            descriptionTextView.text = content
            descriptionTextView.textColor = .label
        }
    }
    
    private let textViewPlaceHolder = "게시글 내용을 작성해주세요. (가품 및 판매금지품목은 게시가 제한될 수 있어요.)"
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static func nib() -> UINib {
        return UINib(nibName: "DetailTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionTextView.delegate = self
        descriptionTextView.font = .systemFont(ofSize: 18)
        descriptionTextView.text = textViewPlaceHolder
        descriptionTextView.textColor = .systemGray
        descriptionTextView.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DetailTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("😅")
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        } else {
            content = textView.text
            textChanged(textView.text)
        }
    }
}

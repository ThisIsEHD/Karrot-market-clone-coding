////
////  ConversationViewCell.swift
////  KarrotMarketCloneCoding
////
////  Created by 서동운 on 2022/10/14.
////
//
//import UIKit
//
//class ConversationViewCell: UITableViewCell {
//    // MARK: - Properties
//    
//    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var bubbleMessage: BubbleMessage!
//    @IBOutlet weak var dateLabel: UILabel!
//    
//    var message: Message? {
//        didSet {
//            guard let message = message else { return }
//            
//            bubbleMessage.text = message.body
//            dateLabel.text = message.sendDate.formatToString()
//            if !message.user!.isMe {
////                profileImageView?.image = message.user.profileImage
//            }
//        }
//    }
//    var style: ChatStyle? {
//        didSet {
//            guard let style = style, let message = message else { return }
//            
//            bubbleMessage.font = style.font
//            bubbleMessage.textColor = message.user!.isMe ? style.outgoingTextColor : style.incomingTextColor
//            bubbleMessage.backgroundColor = message.user!.isMe ? style.outgoingBubbleColor : style.incomingBubbleColor
//            bubbleMessage.textContainerInset = style.bubbleMessageContainerInset
//        }
//    }
//    weak var delegate: UITableViewDelegate?
//    
//    var tapGestureRecognizer: UITapGestureRecognizer!
//    
//    // MARK: - Life Cycle
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        profileImageView?.layer.cornerRadius = 20
//      
//        profileImageView?.layer.masksToBounds = true
//        
//        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
//        profileImageView?.addGestureRecognizer(tapGestureRecognizer)
//        profileImageView?.isUserInteractionEnabled = true
//    }
//    
//    // MARK: - Actions
// 
//    @objc func profileImageTapped(_ sender: UITapGestureRecognizer) {
//        guard let user = message?.user else { return }
//        
//        delegate?.profileImageTapped(user: user)
//    }
//}
//
/////> domb
/////  - 메세지의 inset 오류 해결하기
/////
//class BubbleMessage: UITextView {
//    
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        setupView()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    convenience init() {
//        self.init(frame: .zero, textContainer: nil)
//        setupView()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        self.layer.cornerRadius = 35 / 2
//        self.clipsToBounds = true
//    }
//    
//    func setupView() {
//        
//        dataDetectorTypes = [.flightNumber, .calendarEvent, .address, .phoneNumber, .link, .lookupSuggestion]
//       
//        font = UIFont.preferredFont(forTextStyle: .body)
//        
//        backgroundColor = .clear
//        textColor = .white
//        
//        linkTextAttributes = [NSAttributedString.Key.underlineColor: NSUnderlineStyle.single.rawValue]
//        
//    }
//  
////    func calculatedSize(in size: CGSize) -> CGSize {
////        return sizeThatFits(CGSize(width: size.width * 0.8, height: .infinity))
////    }
//}
//
//
//

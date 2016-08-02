//
//  MessageTableViewCell.swift
//  Wist
//
//  Created by Bryan Ye on 25/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse

class MessageTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var messageLabel: CustomLabel = {
        let label = CustomLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.numberOfLines = 0

        return label
    }()
    
    var message: Message? {
        didSet {
            guard let
                message = message,
//                msgUsername = message.user,
                messageString = message.message
                else { return }
            
            messageLabel.text = messageString

        }
    }
    
    // MARK: - Auto Layout
    
    var didSetupConstraints = false
    
    func setupConstraint() {
        messageLabel.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 1).active = true
        messageLabel.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -1).active = true
        messageLabel.widthAnchor.constraintLessThanOrEqualToConstant(200).active = true
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            setupConstraint()
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}

class OtherUserMessageTableViewCell: MessageTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.backgroundColor = UIColor.grayChatBubbleColor()
        messageLabel.textColor = UIColor.blackColor()
        messageLabel.textAlignment = NSTextAlignment.Left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraint() {
        super.setupConstraint()
        
        messageLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 5).active = true
    }
    
    static let reuseIdentifier = "OtherUserMessageTableViewCell"
}

class CurrentUserMessageTableViewCell: MessageTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.backgroundColor = UIColor.wistPurpleColor()
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = NSTextAlignment.Right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraint() {
        super.setupConstraint()
        
        messageLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -5).active = true
    }
    
    static let reuseIdentifier = "CurrentUserMessageTableViewCell"
}

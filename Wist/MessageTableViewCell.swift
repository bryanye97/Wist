//
//  MessageTableViewCell.swift
//  Wist
//
//  Created by Bryan Ye on 25/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatLabel: CustomLabel!
    
    func setupCell(message: Message, isFromCurrentUser: Bool) {
        chatLabel.text = message.message
        chatLabel.sizeToFit()
        
        NSLayoutConstraint(item: chatLabel,
                           attribute: .Width,
                           relatedBy: .LessThanOrEqual,
                           toItem: chatLabel,
                           attribute: .Width,
                           multiplier: 0,
                           constant: self.contentView.frame.size.width/2).active = true
        
//        NSLayoutConstraint(item: chatLabel,
//                           attribute: .Top,
//                           relatedBy: .Equal,
//                           toItem: self.contentView,
//                           attribute: .Top,
//                           multiplier: 1,
//                           constant: 4).active = true
//        
//        NSLayoutConstraint(item: chatLabel,
//                           attribute: .Bottom,
//                           relatedBy: .Equal,
//                           toItem: self.contentView,
//                           attribute: .Bottom,
//                           multiplier: 1,
//                           constant: -4).active = true
//        

        
        
        if isFromCurrentUser {
            chatLabel.backgroundColor = UIColor.wistPurpleColor()
            chatLabel.textColor = UIColor.whiteColor()
            
            NSLayoutConstraint(item: chatLabel,
                               attribute: .Trailing,
                               relatedBy: .Equal,
                               toItem: self.contentView,
                               attribute: .TrailingMargin,
                               multiplier: 1.0,
                               constant: -4).active = true
            
        } else {
            chatLabel.backgroundColor = UIColor.grayChatBubbleColor()
            chatLabel.textColor = UIColor.blackColor()
            
            NSLayoutConstraint(item: chatLabel,
                               attribute: .Leading,
                               relatedBy: .Equal,
                               toItem: self.contentView,
                               attribute: .LeadingMargin,
                               multiplier: 1.0,
                               constant: 4).active = true
        }
        

        
        chatLabel.layer.cornerRadius = 15
        chatLabel.clipsToBounds = true
        

        
        if isFromCurrentUser{
            chatLabel.textAlignment = NSTextAlignment.Right
        } else {
            chatLabel.textAlignment = NSTextAlignment.Left
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        chatLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MessageTableViewCell.swift
//  Wist
//
//  Created by Bryan Ye on 25/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatLabel: UILabel!
    func setupCell(message: Message, isFromCurrentUser: Bool) {
        chatLabel.layer.cornerRadius = 14
        chatLabel.text = message.message
        //        chatLabel.sizeToFit()
        print(chatLabel.frame.width)
//        let width = chatLabel.frame.size.width
//        let dispWidth = UIScreen.mainScreen().bounds.width
        if isFromCurrentUser{
            chatLabel.textAlignment = NSTextAlignment.Right
            //            chatLabel.center.x = dispWidth - (width / 2 + 10)
        }else{
            chatLabel.textAlignment = NSTextAlignment.Left
            //            chatLabel.center.x = width / 2 + 10
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

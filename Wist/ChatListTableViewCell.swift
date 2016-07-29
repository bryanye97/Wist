//
//  ChatListTableViewCell.swift
//  Wist
//
//  Created by Bryan Ye on 24/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse
import Bond

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var messagingDisposable: DisposableType?
    
    var messaging: Messaging? {
        didSet {
            
            messagingDisposable?.dispose()
            
            if let oldValue = oldValue where oldValue != messaging {
                oldValue.post?.image.value = nil
            }
            
            if let messaging = messaging {
                bookTitleLabel.text = messaging.post?.bookName
                messagingDisposable = messaging.post?.image.bindTo(bookImageView.bnd_image)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookImageView.addBorderAndRadiusToView(1, cornerRadius: bookImageView.frame.width/2)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

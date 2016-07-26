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
    
    var postDisposable: DisposableType?
    
    var post: Post? {
        didSet {
            
            postDisposable?.dispose()
            
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                usernameLabel.text  = post.user?.username
                bookTitleLabel.text = post.bookName
                
                postDisposable = post.image.bindTo(bookImageView.bnd_image)
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bookImageView.addBorderAndRadiusToView(1, cornerRadius: bookImageView.frame.width/2)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

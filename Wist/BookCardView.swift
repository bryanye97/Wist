//
//  BookCardView.swift
//  
//
//  Created by Bryan Ye on 1/07/2016.
//
//

import UIKit
import Parse
import Bond

class BookCardView: UIView {
    
    
    @IBOutlet weak var bookImageView: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var bookNameLabel: UILabel!
    
    var postDisposable: DisposableType?
    var likeDisposable: DisposableType?
    
    var post: Post? {
        didSet {
            
            postDisposable?.dispose()
            likeDisposable?.dispose()
            
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                
                postDisposable = post.image.bindTo(bookImageView.bnd_image)
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
//                    
//                    if let value = value {
//                        
//                        self.likesLabel.text = self.stringFromUserList(value)
//                        
//                        self.likeButton.selected = value.contains(PFUser.currentUser()!)
//                        
//                        self.likesIconImageView.hidden = (value.count == 0)
//                    } else {
//                        
//                        self.likesLabel.text = ""
//                        self.likeButton.selected = false
//                        self.likesIconImageView.hidden = true
//                    }
                }
            }
        }
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

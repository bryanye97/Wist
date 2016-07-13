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
                usernameLabel.text = post.user?.username
                bookNameLabel.text = post.bookName
                postDisposable = post.image.bindTo(bookImageView.bnd_image)
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                }
            }
        }
    }
    
    override func awakeFromNib() {
        bookImageView.layer.borderWidth = 1
        bookImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 0.5).CGColor
        bookImageView.layer.cornerRadius = 10
        bookImageView.layer.masksToBounds = true
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

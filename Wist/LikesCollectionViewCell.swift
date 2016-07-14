//
//  LikesCollectionViewCell.swift
//  Wist
//
//  Created by Bryan Ye on 10/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse
import Bond

class LikesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likesImageView: UIImageView!
    
    var postDisposable: DisposableType?
    var likeDisposable: DisposableType?
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var post: Post? {
        didSet {

            
            postDisposable?.dispose()
            likeDisposable?.dispose()
            
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                
                self.bookNameLabel.text = post.bookName
                
                self.usernameLabel.text = post.user?.username
                
                self.emailLabel.text = post.user?.email ?? "No email available"
                
                postDisposable = post.image.bindTo(likesImageView.bnd_image)
                
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                    
                }
            }
        }
    }
    
    override func awakeFromNib() {
        likesImageView.layer.borderWidth = 1
        likesImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 0.5).CGColor
        likesImageView.layer.cornerRadius = 10
        likesImageView.layer.masksToBounds = true
        
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 0.5).CGColor
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
    
}

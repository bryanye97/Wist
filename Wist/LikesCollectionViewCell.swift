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
    
    var post: Post? {
        didSet {
            
            postDisposable?.dispose()
            likeDisposable?.dispose()
            
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                
                postDisposable = post.image.bindTo(likesImageView.bnd_image)
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                    
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

}

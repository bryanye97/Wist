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
                    
                }
            }
        }
    }
    
    override func awakeFromNib() {
        addBorderAndRadiusToView(self.contentView, borderWidth: 1, cornerRadius: 10)
    }
    
    func stringFromUserList(userList: [PFUser]) -> String {
        let usernameList = userList.map { user in user.username! }
        let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
        
        return commaSeparatedUserList
    }
    
}

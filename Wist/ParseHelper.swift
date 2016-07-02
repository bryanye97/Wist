//
//  ParseHelper.swift
//  Wist
//
//  Created by Bryan Ye on 1/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    static let ParseLikeClass = "Like"
    static let ParseLikeToPost = "toPost"
    static let ParseLikeFromUser = "fromUser"
    
    static func kolodaRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: "Post")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func likePost(user: PFUser, post: Post) {
        let likedObject = PFObject(className: ParseLikeClass)
        likedObject[ParseLikeFromUser] = user
        likedObject[ParseLikeToPost] = post
        
        likedObject.saveInBackgroundWithBlock(nil)
    }
    
    static func unlikePost(user: PFUser, post: Post) {
        
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToPost, equalTo: post)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            
            if let results = results {
                for like in results {
                    like.deleteInBackgroundWithBlock(nil)
                }
            }
        }
    }
}
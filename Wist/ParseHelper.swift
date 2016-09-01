//
//  ParseHelper.swift
//  Wist
//
//  Created by Bryan Ye on 1/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import Foundation
import Parse
import Firebase
import FirebaseDatabase

class ParseHelper {
    
    static let ParsePostClass = "Post"
    static let ParsePostUser = "user"
    
    static let ParseLikeClass = "Like"
    static let ParseLikeToPost = "toPost"
    static let ParseLikeFromUser = "fromUser"
    static let ParseLikeToUser = "toUser"
    
    static let ParseDislikeClass = "Dislike"
    static let ParseDislikeToPost = "toPost"
    static let ParseDislikeFromUser = "fromUser"
    
    static let ParseFlaggedContentClass    = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost   = "toPost"
    
    static let ParseMessagingClass = "Messaging"
    static let ParseMessagingBuyUser = "buyUser"
    static let ParseMessagingSellUser = "sellUser"
    static let ParseMessagingPost = "post"
    static let ParseMessagingChatRoomKey = "chatRoomKey"
    
    static let ParseUserClass = "User"
    
    static func kolodaRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        
        
        let query = Post.query()!
        query.whereKey(ParsePostUser, notEqualTo: PFUser.currentUser()!)
        query.includeKey(ParsePostUser)
        
        
        //        var userGeoPoint: PFGeoPoint?
        
        //        PFGeoPoint.geoPointForCurrentLocationInBackground {
        //            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
        //            if error == nil {
        //                if let geoPoint = geoPoint {
        //                    userGeoPoint = geoPoint
        //                    query.whereKey("location", nearGeoPoint: userGeoPoint!, withinMiles: 80)
        //
        ////                    query.skip = range.startIndex
        ////
        ////                    query.limit = range.endIndex - range.startIndex
        //
        //                    query.findObjectsInBackgroundWithBlock(completionBlock)
        //                } else {
        //                    print("error")
        //                }
        //            }
        //        }
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func postsByCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let query = Post.query()!
        query.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
        query.includeKey(ParsePostUser)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func likePost(user: PFUser, post: Post) {
        
        let likedObject = PFObject(className: ParseLikeClass)
        likedObject[ParseLikeFromUser] = user
        likedObject[ParseLikeToPost] = post
        likedObject[ParseLikeToUser] = post.user
        
        likedObject.saveInBackgroundWithBlock(nil)
    }
    
    static func unlikePost(user: PFUser, post: Post) {
        
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToPost, equalTo: post)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            
            if let results = results {
                for like in results {
                    like.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
                }
            }
        }
    }
    
    static func dislikePost(user: PFUser, post: Post) {
        let dislikedObject = PFObject(className: ParseDislikeClass)
        dislikedObject[ParseDislikeFromUser] = user
        dislikedObject[ParseDislikeToPost] = post
        
        dislikedObject.saveInBackgroundWithBlock(nil)
    }
    
    
    static func likesRequestForCurrentUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let likesQuery = PFQuery(className: ParseLikeClass)
        likesQuery.whereKey(ParseLikeFromUser, equalTo: user)
        likesQuery.includeKey(ParseLikeToPost)
        
        likesQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func likesRequestToCurrentUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let likesQuery = PFQuery(className: ParseLikeClass)
        likesQuery.whereKey(ParseLikeToUser, equalTo:user)
        likesQuery.includeKey(ParseLikeToPost)
        
        likesQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func dislikesRequestForCurrentUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let dislikesQuery = PFQuery(className: ParseDislikeClass)
        dislikesQuery.whereKey(ParseDislikeFromUser, equalTo: user)
        dislikesQuery.includeKey(ParseDislikeToPost)
        
        dislikesQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func userWithPostsObjectId(objectIds: [String], completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParsePostClass)
        
        query.whereKey("objectId", containedIn: objectIds)
        query.includeKey("user")
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func usersContainedInObjectId(objectIds: [String], completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseUserClass)
        query.whereKey("objectId", containedIn: objectIds)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    static func likesForPost(post: Post, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeToPost, equalTo: post)
        query.includeKey(ParseLikeFromUser)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func flagPost(user: PFUser, post: Post) {
        let flagObject = PFObject(className: ParseFlaggedContentClass)
        flagObject.setObject(user, forKey: ParseFlaggedContentFromUser)
        flagObject.setObject(post, forKey: ParseFlaggedContentToPost)
        
        let ACL = PFACL(user: PFUser.currentUser()!)
        ACL.publicReadAccess = true
        flagObject.ACL = ACL
        
        flagObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
    }
    
    static func messagingObjectForBuyUserSellUserAndPost(buyUser: PFUser, sellUser: PFUser, post: Post, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseMessagingClass)
        query.whereKey(ParseMessagingBuyUser, equalTo: buyUser)
        query.whereKey(ParseMessagingSellUser, equalTo: sellUser)
        query.whereKey(ParseMessagingPost, equalTo: post)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func messagingObjectsForBuyUser(buyUser: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseMessagingClass)
        query.whereKey(ParseMessagingBuyUser, equalTo: buyUser)
        query.includeKey(ParseMessagingBuyUser)
        query.includeKey(ParseMessagingSellUser)
        query.includeKey(ParseMessagingPost)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func messagingObjectsForSellUser(sellUser: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseMessagingClass)
        query.whereKey(ParseMessagingSellUser, equalTo: sellUser)
        query.includeKey(ParseMessagingBuyUser)
        query.includeKey(ParseMessagingSellUser)
        query.includeKey(ParseMessagingPost)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}

extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
}
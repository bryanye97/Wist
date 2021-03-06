//
//  Post.swift
//  Wist
//
//  Created by Bryan Ye on 30/06/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit


class Post: PFObject, PFSubclassing {
    
    static var imageCache: NSCacheSwift<String, UIImage>!
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    var image: Observable<UIImage?> = Observable(nil)
    
    var likes: Observable<[PFUser]?> = Observable(nil)
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var bookName: String?
    @NSManaged var bookCondition: String?
    @NSManaged var bookGenre: String?
    @NSManaged var bookPrice: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var user: PFUser?
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
            Post.imageCache = NSCacheSwift<String, UIImage>()
        }
    }
    
    func uploadPost() {
        if let image = image.value {
            
            guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            user = PFUser.currentUser()
            self.imageFile = imageFile
            
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler{ () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if error == nil {
                    
                    self.location = geoPoint!
                    
                    self.saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                        
                        if let error = error {
                            ErrorHandling.defaultErrorHandler(error)
                        }
                        
                        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
                    }
                }
            }
        }
    }
    
    func downloadImage() {
        image.value = Post.imageCache[self.imageFile!.name]
        
        if image.value == nil {
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.image.value = image
                    
                    Post.imageCache[self.imageFile!.name] = image
                }
            }
        }
    }
    
    func fetchLikes() {
        if (likes.value != nil) {
            return
        }
        ParseHelper.likesForPost(self, completionBlock: { (likes: [PFObject]?, error: NSError?) -> Void in
            let validLikes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil }
            
            self.likes.value = validLikes?.map { like in
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
                
                return fromUser
            }
        })
    }
    
    func doesUserLikePost(user: PFUser) -> Bool {
        if let likes = likes.value {
            return likes.contains(user)
        } else {
            return false
        }
    }
    
    func toggleLikePost(user: PFUser) {
        if (doesUserLikePost(user)) {
            
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.unlikePost(user, post: self)
        } else {
            
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
    
    func flagPost(user: PFUser) {
        ParseHelper.flagPost(user, post: self)
    }
}
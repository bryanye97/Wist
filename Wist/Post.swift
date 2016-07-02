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
    
//  var image: Observable<UIImage?> = Observable(nil)
    var image: UIImage?
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var bookName: String?
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
            
            
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
                
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    
//    func downloadImage() {
//        image.value = Post.imageCache[self.imageFile!.name]
//        
//        if image.value == nil {
//            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
//                if let data = data {
//                    let image = UIImage(data: data, scale:1.0)!
//                    self.image.value = image
//                    
//                    Post.imageCache[self.imageFile!.name] = image
//                }
//            }
//        }
//    }
}
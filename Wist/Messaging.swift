//
//  Messaging.swift
//  Wist
//
//  Created by Bryan Ye on 27/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import Foundation
import Parse

class Messaging: PFObject, PFSubclassing {
    
    
    
    @NSManaged var buyUser: PFUser?
    @NSManaged var sellUser: PFUser?
    @NSManaged var post: Post?
    @NSManaged var chatRoomKey: String?
    
    static func parseClassName() -> String {
        return "Messaging"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    func uploadPost() {
        
        guard buyUser != nil else { return }
        guard sellUser != nil else { return }
        guard post != nil else { return }
        guard chatRoomKey != nil else { return }
        
        self.saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
        }
    }
}
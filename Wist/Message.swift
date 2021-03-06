//
//  Message.swift
//  Wist
//
//  Created by Bryan Ye on 25/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import Foundation
import Firebase

class Message {
    let user: String?
    let message: String?
    var date: NSDate?
    
    init(dictFromFIR: [String: AnyObject]){
        date = (dictFromFIR["date"] ?? NSDate(timeIntervalSince1970: 0)) as? NSDate
        message = (dictFromFIR["message"] as! String) ?? ""
        user = (dictFromFIR["sender"] as! String) ?? "NoUsername"
    }
    
    init (snap: FIRDataSnapshot) {
        let s = snap.value as! [String: AnyObject]
        user = s["sender"] as? String ?? ""
        message = s["message"] as? String ?? ""
        date = s["date"] as? NSDate ?? NSDate(timeIntervalSince1970: 0)
    }
    
    init(user: String, messageString: String){
        date = NSDate()
        message = messageString
        self.user = user
    }
    
    func toDict() -> [String: AnyObject]{
        return ["message": message!, "user": user!, "date": (date?.timeIntervalSince1970)!]
    }
}
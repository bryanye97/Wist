//
//  Message.swift
//  Wist
//
//  Created by Bryan Ye on 25/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import Foundation

class Message {
    let user: String?
    let message: String?
    var date: NSDate?
    
    init(){
        date = nil
        message = nil
        user = nil
    }
    init(dictFromFIR: [String: AnyObject]){
        date = (dictFromFIR["date"] ?? NSDate(timeIntervalSince1970: 0)) as? NSDate
        message = (dictFromFIR["message"] as! String) ?? ""
        user = (dictFromFIR["sender"] as! String) ?? "NoUsername"
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
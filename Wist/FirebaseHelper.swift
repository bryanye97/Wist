//
//  FirebaseHelper.swift
//  Wist
//
//  Created by Bryan Ye on 25/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseHelper {
    
    static var ref = FIRDatabase.database().reference()
    
//    static func checkIfMessagesExistInChatRoom(chatRoomKey: String) {
//        FirebaseHelper.ref.child("Messaging").child(chatRoomKey).observeSingleEventOfType(.Value) { (snapshot) in
//            print(snapshot.value)
//            if snapshot.value != nil {
//                
//            }
//        }
//    }
    
    static func addMessage(chatroomRef: FIRDatabaseReference, sender: String, message: String) {
        chatroomRef.childByAutoId().setValue(createMessagingDictionary(sender, message: message))
    }
    
    static func createMessagingDictionary(sender: String, message: String) -> [String: AnyObject] {
        return ["sender": sender, "message": message, "date": NSDate().timeIntervalSince1970]
    }
    
    static func createNewChatroom(rootRef: FIRDatabaseReference) -> FIRDatabaseReference {
        let chatroomRef = rootRef.child("Messaging").childByAutoId()
        return chatroomRef
    }
    
//    static func uploadMessage(message: Message, chatRoomKey: String) {
//        
//    }
}
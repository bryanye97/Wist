//
//  MessageViewController.swift
//  Wist
//
//  Created by Bryan Ye on 24/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MessageViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference()
    
    let myOwnChatName = PFUser.currentUser()!.username
    
    var messageArray: [Message] = []
    
    var messagingObject: Messaging? {
        didSet {
            buyUser = messagingObject?.buyUser
            sellUser = messagingObject?.sellUser
            post = messagingObject?.post
            chatRoomKey = messagingObject?.chatRoomKey
        }
    }
    
    var buyUser: PFUser?
    var sellUser: PFUser?
    var post: Post?
    var chatRoomKey: String?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        print(buyUser)
        print(sellUser)
        print(post)
        print("check chatRoomKey : \(chatRoomKey)")
        
        guard let buyUser = buyUser else { return }
        guard let sellUser = sellUser else { return }
        guard let post = post else { return }
        
        ParseHelper.messagingObjectForBuyUserSellUserAndPost(buyUser, sellUser: sellUser, post: post) { (result: [PFObject]?, error: NSError?) in
            guard let result = result else { return }
            
            self.chatRoomKey = result[0]["chatRoomKey"] as? String

            print("check chatRoomKey again: \(self.chatRoomKey)")
            
            guard let chatRoomKey = self.chatRoomKey else { return }
            
            self.ref.child("Messaging").child(chatRoomKey).observeEventType(.Value) { (snap: FIRDataSnapshot) in
                self.messageArray = []
                for s in snap.children{
                    print(s)
                    self.messageArray.append(Message(dictFromFIR: (s as! FIRDataSnapshot).value as! [String: AnyObject]))
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if messageTextField.text?.characters.count > 0 {
            
            if chatRoomKey == nil {

                let newChatRoom = FirebaseHelper.createNewChatroom(self.ref)
                chatRoomKey = newChatRoom.key
                
                guard let buyUser = buyUser else { return }
                guard let sellUser = sellUser else { return }
                guard let post = post else { return }
                guard let chatRoomKey = chatRoomKey else { return }
                
                let messaging = Messaging()
                messaging.buyUser = buyUser
                messaging.sellUser = sellUser
                messaging.post = post
                messaging.chatRoomKey = chatRoomKey
                messaging.uploadPost()
                
            }
            
            guard let chatRoomKey = chatRoomKey else { return }
            
            FirebaseHelper.addMessage(ref.child("Messaging").child(chatRoomKey), sender: myOwnChatName ?? "", message: messageTextField.text ?? "")
            messageTextField.text = ""
            resignFirstResponder()
            tableView.reloadData()
        }
    }
    
    
}

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MessageTableViewCell
        let message = messageArray[indexPath.row]
        cell.setupCell(message,isFromCurrentUser: (myOwnChatName == message.user))
        return cell
    }
}

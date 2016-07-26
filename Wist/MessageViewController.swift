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
import JSQMessagesViewController

class MessageViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference()
    
    let myOwnChatName = PFUser.currentUser()!.username
    var chatRoomKey: String?
    var messageArray: [Message] = []
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("chat room key shoudl be set : \(chatRoomKey)")
        ref.child("Messaging").child(chatRoomKey!).observeEventType(.Value) { (snap: FIRDataSnapshot) in
            self.messageArray = []
            for s in snap.children{
                print(s)
                
                self.messageArray.append(Message(dictFromFIR: (s as! FIRDataSnapshot).value as! [String: AnyObject]))
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if messageTextField.text?.characters.count > 0 {
            //            let message = Message(user: myOwnChatName ?? "", messageString: messageTextField.text!)
            guard let chatRoomKey = chatRoomKey else {return}
            print(chatRoomKey)
            FirebaseHelper.addMessage(ref.child("Messaging").child(chatRoomKey), sender: myOwnChatName ?? "", message: messageTextField.text ?? "")
            messageTextField.text = ""
            resignFirstResponder()
            //            messageArray.append(message)
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

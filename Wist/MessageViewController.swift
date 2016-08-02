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
    
    @IBOutlet weak var otherUsernameLabel: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var sendMessageView: UIView!
    
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
    
    var otherUsername: String?
    
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
        
        navigationView.layer.addBorder(.Bottom, color: .lightGrayBorder(), thickness: 1.5)
        sendMessageView.layer.addBorder(.Top, color: .lightGrayBorder(), thickness: 1.5)
        

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.registerClass(CurrentUserMessageTableViewCell.self,
                                forCellReuseIdentifier: CurrentUserMessageTableViewCell.reuseIdentifier)
        tableView.registerClass(OtherUserMessageTableViewCell.self,
                                forCellReuseIdentifier: OtherUserMessageTableViewCell.reuseIdentifier)
        
        
        otherUsernameLabel.text = otherUsername ?? ""
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(MessageViewController.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(MessageViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(MessageViewController.keyboardDidShow(_:)),
                                                         name:UIKeyboardDidShowNotification,
                                                         object: nil);
        
        messageTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        guard let buyUser = buyUser else { return }
        guard let sellUser = sellUser else { return }
        guard let post = post else { return }
        
        ParseHelper.messagingObjectForBuyUserSellUserAndPost(buyUser, sellUser: sellUser, post: post) { (result: [PFObject]?, error: NSError?) in
            guard let result = result else { return }
            
            self.chatRoomKey = result[0]["chatRoomKey"] as? String
            
            guard let chatRoomKey = self.chatRoomKey else { return }
            
            self.ref.child("Messaging").child(chatRoomKey).observeEventType(.Value) { (snap: FIRDataSnapshot) in
                self.messageArray = []
                for s in snap.children {
                    self.messageArray.append(Message(dictFromFIR: (s as! FIRDataSnapshot).value as! [String: AnyObject]))
                    self.tableView.reloadData()
                    self.scrollToBottomMessage()
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
            self.ref.child("Messaging").child(chatRoomKey).observeEventType(.Value) { (snap: FIRDataSnapshot) in
                self.messageArray = []
                for s in snap.children {
                    self.messageArray.append(Message(dictFromFIR: (s as! FIRDataSnapshot).value as! [String: AnyObject]))
                    self.tableView.reloadData()
                    self.scrollToBottomMessage()
                }
            }

        }
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height)
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func scrollToBottomMessage() {
        guard messageArray.count != 0 else { return }
        
        let bottomMessageIndex = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1,
                                             inSection: 0)
        self.tableView.scrollToRowAtIndexPath(bottomMessageIndex, atScrollPosition: .Bottom,
                                              animated: true)
    }
    
   	func keyboardDidShow(notification: NSNotification) {
        self.scrollToBottomMessage()
    }
    
}

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: MessageTableViewCell
        let message = messageArray[indexPath.row]
        if let msgUsername = message.user where msgUsername == myOwnChatName {
            cell = tableView.dequeueReusableCellWithIdentifier(CurrentUserMessageTableViewCell.reuseIdentifier) as! CurrentUserMessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(OtherUserMessageTableViewCell.reuseIdentifier) as! OtherUserMessageTableViewCell
        }
        
        cell.message = message
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
}

extension MessageViewController: UITextFieldDelegate {
}
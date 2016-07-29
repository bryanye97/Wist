//
//  ChatListViewController.swift
//  Wist
//
//  Created by Bryan Ye on 24/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse
import Firebase
import FirebaseDatabase

class ChatListViewController: UIViewController {
    
    var messagingArray: [[Messaging]] {
        return [buyMessagingArray, sellMessagingArray]
    }
    
    private var buyMessagingArray = [Messaging]()
    private var sellMessagingArray = [Messaging]()
    
    private var messagingObjectForChatSelected: Messaging?
    private var otherUsernameForChatSelected: String?
    
    
    var loaded = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.messagingObjectsForBuyUser(PFUser.currentUser()!) { (result: [PFObject]?, error: NSError?) in
            guard let result = result else { return }
            
            self.buyMessagingArray = result as? [Messaging] ?? []
            
            ParseHelper.messagingObjectsForSellUser(PFUser.currentUser()!, completionBlock: { (result: [PFObject]?, error: NSError?) in
                guard let result = result else { return }
                
                self.sellMessagingArray = result as? [Messaging] ?? []
                
                self.tableView.reloadData()
                self.loaded = true
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "message" {
            let destinationViewController = segue.destinationViewController as! MessageViewController
            destinationViewController.messagingObject = self.messagingObjectForChatSelected
            if otherUsernameForChatSelected == otherUsernameForChatSelected {
              destinationViewController.otherUsername = otherUsernameForChatSelected
            }
        }
    }
    
    @IBAction func unwindToChatList(segue: UIStoryboardSegue) {
    }
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            messagingObjectForChatSelected = buyMessagingArray[indexPath.row]
            otherUsernameForChatSelected = buyMessagingArray[indexPath.row].sellUser?.username
        } else if indexPath.section == 1 {
            messagingObjectForChatSelected = sellMessagingArray[indexPath.row]
            otherUsernameForChatSelected = buyMessagingArray[indexPath.row].buyUser?.username
        }
        self.performSegueWithIdentifier("message", sender: self)
    }
    
}

extension ChatListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messagingArrayForSection = messagingArray[indexPath.section]
        let messagingObject = messagingArrayForSection[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ChatListTableViewCell
        cell.messaging = messagingObject
        cell.messaging?.post?.downloadImage()
        
        if indexPath.section == 0 {
            cell.usernameLabel.text = messagingObject.sellUser?.username
        } else if indexPath.section == 1 {
            cell.usernameLabel.text = messagingObject.buyUser?.username
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messagingArray[0].count > 0 || messagingArray[1].count > 0 {
            return messagingArray[section].count
        } else {
            if loaded {
                let messageLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height))
                messageLabel.text = "You haven't saved any books. Go and like some!"
                messageLabel.textColor = UIColor.blackColor()
                messageLabel.numberOfLines = 0
                messageLabel.textAlignment = .Center
                messageLabel.font = UIFont(name: "Helvetica Neue", size: 15)
                messageLabel.sizeToFit()
                tableView.backgroundView = messageLabel
            }
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Buy books"
        } else if section == 1 {
            return "Sell books"
        } else {
            return nil
        }
    }
}
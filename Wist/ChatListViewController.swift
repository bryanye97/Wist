//
//  ChatListViewController.swift
//  Wist
//
//  Created by Bryan Ye on 24/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse

class ChatListViewController: UIViewController {
    
    private var likedPosts = [Post]()
    
    private var yourPostsThatHaveBeenLiked = [Post]()
    
    private var chatRoomKeysForPostsYouLiked = [String]()
    
    private var chatRoomKeysForYourPostsThatHaveBeenLiked = [String]()
    
    var chatRoomKeyToAccess: String?
    
    var loaded = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.likesRequestForCurrentUser(PFUser.currentUser()!) {(result: [PFObject]?, error: NSError?) in
            guard let result = result else {
                return
            }
            
            self.chatRoomKeysForPostsYouLiked = result.map({ (like: PFObject) -> String in
                like["chatRoomKey"] as! String
            })
            
            let postArray = result.map({ (like: PFObject) -> Post in
                like["toPost"] as! Post
            })
            
            let objectIdArray = postArray.map({
                $0.objectId!
            })
            
            ParseHelper.userWithPostsObjectId(objectIdArray, completionBlock: { (result:[PFObject]?, error: NSError?) in
                guard let result = result else { return }
                
                self.likedPosts = result as? [Post] ?? []
                
                ParseHelper.likesRequestToCurrentUser(PFUser.currentUser()!, completionBlock: { (result: [PFObject]?, error: NSError?) in
                    guard let result = result else { return }
                    
                    
                    self.chatRoomKeysForPostsYouLiked = result.map({ (like: PFObject) -> String in
                        like["chatRoomKey"] as! String
                    })
                    
                    let postArray = result.map({ (like: PFObject) -> Post in
                        like["toPost"] as! Post
                    })
                    
                    let objectIdArray = postArray.map({
                        $0.objectId!
                    })
                    
                    ParseHelper.userWithPostsObjectId(objectIdArray, completionBlock: { (result: [PFObject]?, error: NSError?) in
                        guard let result = result else { return }
                        
                        self.yourPostsThatHaveBeenLiked = result as? [Post] ?? []
                        
                        self.tableView.reloadData()
                        self.loaded = true
                    })
                    
                })
                
                
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
            destinationViewController.chatRoomKey = chatRoomKeyToAccess
        }
    }
    
    @IBAction func unwindToChatList(segue: UIStoryboardSegue) {
    }
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.row)")
        chatRoomKeyToAccess = chatRoomKeysForPostsYouLiked[indexPath.row]
        self.performSegueWithIdentifier("message", sender: self)
    }
    
}

extension ChatListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = likedPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ChatListTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        post.downloadImage()
        cell.post = post
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return likedPosts.count
        } else if section == 1 {
            return yourPostsThatHaveBeenLiked.count
        } else {
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

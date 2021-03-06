//
//  BookInformationViewController.swift
//  Wist
//
//  Created by Bryan Ye on 14/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse

class BookInformationViewController: UIViewController {
    
    var post: Post?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            bookTitleLabel.text = post.bookName ?? ""
            bookImageView.image = post.image.value
            emailLabel.text = post.user?.email ?? ""
            conditionLabel.text = post.bookCondition ?? ""
            genreLabel.text = post.bookGenre ?? ""
            priceLabel.text = post.bookPrice ?? ""
        }
        
    }
    
    @IBAction func messageButtonTapped(sender: UIButton) {
        self.performSegueWithIdentifier("message", sender: self)
    }
    
    
    @IBAction func unlikePost(sender: UIButton) {
        if let post = post {
            if let currentUser = PFUser.currentUser() {
                ParseHelper.unlikePost(currentUser, post: post)
                self.performSegueWithIdentifier("unwindToLikes", sender: self)
            }
        }
    }
    
    @IBAction func flagButtonTapped(sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        alertController.view.tintColor = .wistPurpleColor()
        
        let reportAction = UIAlertAction(title: "Report Content", style: .Default) { (action) in
            if let post = self.post {
                if let currentUser = PFUser.currentUser() {
                    post.flagPost(currentUser)
                    ParseHelper.unlikePost(currentUser, post: post)
                    self.performSegueWithIdentifier("unwindToLikes", sender: self)
                }
            }
        }
        alertController.addAction(reportAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "message" {
            let destinationViewController = segue.destinationViewController as! MessageViewController
            if let currentUser = PFUser.currentUser() {
                destinationViewController.buyUser = currentUser
            }
            
            guard let post = post else { return }
            destinationViewController.sellUser = post.user
            destinationViewController.post = post
        }
    }
}

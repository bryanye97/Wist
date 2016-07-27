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
            bookTitleLabel.text = post.bookName!
            bookImageView.image = post.image.value
            emailLabel.text = post.user?.email
            conditionLabel.text = post.bookCondition
            genreLabel.text = post.bookGenre
            priceLabel.text = post.bookPrice
        }
        
    }
    
    @IBAction func messageButtonTapped(sender: UIButton) {
        self.performSegueWithIdentifier("message", sender: self)
    }
    
    
    @IBAction func unlikePost(sender: UIButton) {
        if let post = post {
            ParseHelper.unlikePost(PFUser.currentUser()!, post: post)
        }
        
    }
    
    @IBAction func flagButtonTapped(sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        alertController.view.tintColor = .blackColor()
        
        let reportAction = UIAlertAction(title: "Report Content", style: .Default) { (action) in
            self.post?.flagPost(PFUser.currentUser()!)
        }
        alertController.addAction(reportAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "message" {
            let destinationViewController = segue.destinationViewController as! MessageViewController
            destinationViewController.buyUser = PFUser.currentUser()!
            destinationViewController.sellUser = post?.user
            destinationViewController.post = post
        }
    }
}

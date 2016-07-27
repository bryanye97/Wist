//
//  BooksViewController.swift
//  Wist
//
//  Created by Bryan Ye on 30/06/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Koloda
import Parse
import ConvenienceKit

class BooksViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: WistKolodaView!
    
    private var allPosts = [Post]()
    
    private var likedPosts = [Post]()
    
    private var dislikedPosts = [Post]()
    
    private var unseenPosts = [Post]()
    
    var bookToDisplay: Post?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.kolodaRequestForCurrentUser {(result: [PFObject]?, error: NSError?) -> Void in
            
            guard let result = result else { return }
            
            self.allPosts = result as? [Post] ?? []

            ParseHelper.likesRequestForCurrentUser(PFUser.currentUser()!) {(result: [PFObject]?, error: NSError?) in
                guard let result = result else { return }
                
                let postArray = result.map({ (like: PFObject) -> Post in
                    like["toPost"] as! Post
                })
                
                let objectIdArray = postArray.map({
                    $0.objectId!
                })
                
                ParseHelper.userWithPostsObjectId(objectIdArray, completionBlock: { (result:[PFObject]?, error: NSError?) in
                    self.likedPosts = result as? [Post] ?? []
                })
                ParseHelper.dislikesRequestForCurrentUser(PFUser.currentUser()!) {(result: [PFObject]?, error: NSError?) in
                    guard let result = result else { return }
                    
                    let postArray = result.map({ (like: PFObject) -> Post in
                        like["toPost"] as! Post
                    })
                    
                    let objectIdArray = postArray.map({
                        $0.objectId!
                    })
                    
                    ParseHelper.userWithPostsObjectId(objectIdArray, completionBlock: { (result:[PFObject]?, error: NSError?) in
                        self.dislikedPosts = result as? [Post] ?? []
                        self.unseenPosts = self.allPosts.filter({ (post) -> Bool in
                            return !self.likedPosts.contains(post) && !self.dislikedPosts.contains(post)
                        })
                        self.kolodaView.reloadData()
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        let post = unseenPosts[Int(index)]
        if direction == SwipeResultDirection.Right {
            ParseHelper.likePost(PFUser.currentUser()!, post: post)
        } else if direction == SwipeResultDirection.Left {
            ParseHelper.dislikePost(PFUser.currentUser()!, post: post)
        }
    }
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func dislikeButtonTapped(sender: UIButton) {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewBookPreview" {
            let destinationViewController = segue.destinationViewController as! BookPreviewViewController
            destinationViewController.post = bookToDisplay
        }
    }

    
    @IBAction func unwindToBooks(segue: UIStoryboardSegue) {
    }
}

extension BooksViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        kolodaView.displayBackgroundView()
        print("out of books")
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        self.bookToDisplay = self.unseenPosts[Int(index)]
        self.performSegueWithIdentifier("viewBookPreview", sender: self)

     
    }
}

extension BooksViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(unseenPosts.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let post = unseenPosts[Int(index)]
        
        let cardView = NSBundle.mainBundle().loadNibNamed("BookCardView", owner: self, options: nil)[0] as! BookCardView
        post.downloadImage()
        cardView.post = post
        return cardView
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}

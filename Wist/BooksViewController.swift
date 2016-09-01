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
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    private var allPosts = [Post]()
    
    private var likedPosts = [Post]()
    
    private var dislikedPosts = [Post]()
    
    private var unseenPosts = [Post]()
    
    var emptyKolodaView: UIView?
    
    var loaded = false
    
    var bookToDisplay: Post?
    
    //    var range = 0...4
    //
    //    let additionalRangeSize = 5
    //
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.kolodaRequestForCurrentUser {(result: [PFObject]?, error: NSError?) -> Void in
            //
            //            self.range.startIndex += self.additionalRangeSize
            //            self.range.endIndex += self.additionalRangeSize
            
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
                            
                            //                            if self.unseenPosts.count == 0 {
                            //                                kolodaView.countOfCards == 0
                            //                            }
                            self.loaded = true
                            self.kolodaView.reloadData()
                            
                        })
                    }
                })
                
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
    
    func hideButtons() {
        likeButton.hidden = true
        dislikeButton.hidden = true
    }
    
    func showButtons() {
        likeButton.hidden = false
        dislikeButton.hidden = false
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
        emptyKolodaView = NSBundle.mainBundle().loadNibNamed("EmptyKolodaView",
                                                             owner: self,
                                                             options: nil)[0] as? EmptyKolodaView
        emptyKolodaView!.frame = view.frame
        hideButtons()
        self.view.addSubview(emptyKolodaView!)
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        self.bookToDisplay = self.unseenPosts[Int(index)]
        self.performSegueWithIdentifier("viewBookPreview", sender: self)
    }
}

extension BooksViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        if unseenPosts.count == 0 {
            if loaded {
                emptyKolodaView = NSBundle.mainBundle().loadNibNamed("EmptyKolodaView",
                                                                     owner: self,
                                                                     options: nil)[0] as? EmptyKolodaView
                emptyKolodaView!.frame = view.frame
                hideButtons()
                self.view.addSubview(emptyKolodaView!)
            }
        } else {
            emptyKolodaView?.removeFromSuperview()
            showButtons()
        }
        
        return UInt(unseenPosts.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let post = unseenPosts[Int(index)]
        
        let cardView = NSBundle.mainBundle().loadNibNamed("BookCardView", owner: self, options: nil)[0] as! BookCardView
        post.downloadImage()
        cardView.post = post
        return cardView
    }
    
    //    func koloda(koloda: KolodaView, didShowCardAtIndex index: UInt) {
    //        if Int(index) == (Int(kolodaNumberOfCards(koloda)) - 1) {
    //
    //            ParseHelper.kolodaRequestForCurrentUser(range) {(result: [PFObject]?, error: NSError?) -> Void in
    //
    ////                self.range.startIndex += self.additionalRangeSize
    ////                self.range.endIndex += self.additionalRangeSize
    //
    //                guard let result = result else { return }
    //
    //                self.allPosts = result as? [Post] ?? []
    //
    //                ParseHelper.likesRequestForCurrentUser(PFUser.currentUser()!) {(result: [PFObject]?, error: NSError?) in
    //                    guard let result = result else { return }
    //
    //                    let postArray = result.map({ (like: PFObject) -> Post in
    //                        like["toPost"] as! Post
    //                    })
    //
    //                    let objectIdArray = postArray.map({
    //                        $0.objectId!
    //                    })
    //
    //                    ParseHelper.userWithPostsObjectId(objectIdArray, completionBlock: { (result:[PFObject]?, error: NSError?) in
    //                        self.likedPosts = result as? [Post] ?? []
    //
    //                        ParseHelper.dislikesRequestForCurrentUser(PFUser.currentUser()!) {(result: [PFObject]?, error: NSError?) in
    //                            guard let result = result else { return }
    //
    //                            let postArray = result.map({ (like: PFObject) -> Post in
    //                                like["toPost"] as! Post
    //                            })
    //
    //                            let objectIdArray = postArray.map({
    //                                $0.objectId!
    //                            })
    //
    //                            ParseHelper.userWithPostsObjectId(objectIdArray, completionBlock: { (result:[PFObject]?, error: NSError?) in
    //                                self.dislikedPosts = result as? [Post] ?? []
    //                                self.unseenPosts = self.allPosts.filter({ (post) -> Bool in
    //                                    return !self.likedPosts.contains(post) && !self.dislikedPosts.contains(post)
    //                                })
    //
    //                                self.kolodaView.reloadData()
    //                                self.loaded = true
    //                            })
    //                        }
    //                    })
    //
    //                }
    //            }
    //        }
    //    }
    //    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}

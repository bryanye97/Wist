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
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    private lazy var dataSource = [Post]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.kolodaRequestForCurrentUser {(result: [PFObject]?, error: NSError?) -> Void in
            
            guard let result = result else {
                return
            }
            
            self.dataSource = result as? [Post] ?? []
            
            for post in self.dataSource {
                do {
                    let imageData = try post.imageFile?.getData()
                    post.image.value = UIImage(data: imageData!, scale:1.0)
                } catch {
                    print("could not get image")
                }
            }
            
            self.kolodaView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        let post = dataSource[Int(index)]
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
}

extension BooksViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("out of books")
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save item", style: .Default) { (action) in
        }
        alertController.addAction(saveAction)
        
        let messageAction = UIAlertAction(title: "Message seller", style: .Default) { (action) in
            self.performSegueWithIdentifier("testSegue", sender: self)
        }
        alertController.addAction(messageAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension BooksViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(dataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let post = dataSource[Int(index)]
        
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

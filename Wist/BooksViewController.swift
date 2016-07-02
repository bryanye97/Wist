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

class BooksViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    private var dataSource = [Post]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.kolodaRequestForCurrentUser {(result: [PFObject]?, error: NSError?) -> Void in
            
            self.dataSource = result as? [Post] ?? []
            
            for post in self.dataSource {
                do {
                    let imageData = try post.imageFile?.getData()
                    post.image = UIImage(data: imageData!, scale:1.0)
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
        if direction == SwipeResultDirection.Right {
            let post = dataSource[Int(index)]
            ParseHelper.likePost(post.user!, post: post)
        }
    }
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func dislikeButtonTapped(sender: UIButton) {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BooksViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        dataSource.reset()
        
        print("out of books")
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://google.com/")!)
        print("Card selected!")
    }
}

extension BooksViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(dataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let post = dataSource[Int(index)]
        let image = post.image
        let bookName = post.bookName
        let username = post.user?.username
        
        let cardView = NSBundle.mainBundle().loadNibNamed("BookCardView", owner: self, options: nil)[0] as! BookCardView
        cardView.bookImageView.image = image
        cardView.usernameLabel.text = username
        cardView.bookNameLabel.text = bookName
        
        return cardView
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}
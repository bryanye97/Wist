//
//  LikesViewController.swift
//  Wist
//
//  Created by Bryan Ye on 10/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse

class LikesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var likedPosts = [Post]()
    
    var bookToDisplay: Post?
    
    var loaded = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
                
                self.collectionView.reloadData()
                self.loaded = true
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBookInformationSegue" {
            let destinationViewController = segue.destinationViewController as! BookInformationViewController
            destinationViewController.post = bookToDisplay
        }
    }
    
    @IBAction func unwindToLikes(segue: UIStoryboardSegue) {
    }
}

extension LikesViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.bookToDisplay = self.likedPosts[indexPath.row]
        self.performSegueWithIdentifier("showBookInformationSegue", sender: self)
    }
}


extension LikesViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedPosts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = likedPosts[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! LikesCollectionViewCell
        post.downloadImage()
        cell.post = post
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if likedPosts.count > 0 {
            collectionView.backgroundView?.hidden = true
            return 1
        } else {
            if self.loaded == true {
                let messageLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height))
                messageLabel.text = "You haven't saved any books. Go and like some!"
                messageLabel.textColor = UIColor.blackColor()
                messageLabel.numberOfLines = 0
                messageLabel.textAlignment = .Center
                messageLabel.font = UIFont(name: "Helvetica Neue", size: 15)
                messageLabel.sizeToFit()
                collectionView.backgroundView = messageLabel
            }
            return 0
        }
    }
}

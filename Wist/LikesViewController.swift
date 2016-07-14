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
    
    private var likesSource = [Post]()
    
    var bookToDisplay: Post?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        ParseHelper.likesRequestForCurrentUser(PFUser.currentUser()!) {(result: [PFObject]?, error: NSError?) in
            guard let result = result else {
                return
            }
            
            let postArray = result.map({ (like: PFObject) -> Post in
                like["toPost"] as! Post
            })
            
            let objectIdArray = postArray.map({
                $0.objectId!
            })
            
            ParseHelper.userWithPostsObjectId(objectIdArray, completionBlock: { (result:[PFObject]?, error: NSError?) in
                self.likesSource = result as? [Post] ?? []
                
                for post in self.likesSource {
                    do {
                        let imageData = try post.imageFile?.getData()
                        post.image.value = UIImage(data: imageData!, scale:1.0)
                    } catch {
                        print("could not get image")
                    }
                }
                
                self.collectionView.reloadData()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.bookToDisplay = self.likesSource[indexPath.row]
        self.performSegueWithIdentifier("showBookInformationSegue", sender: self)
    }
}


extension LikesViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likesSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = likesSource[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! LikesCollectionViewCell
        
        
        cell.backgroundColor = UIColor.clearColor()
        
        post.downloadImage()
        cell.post = post
        return cell
    }
}

extension LikesViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Welcome"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "THIS IS A BUTTON"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "ic_face")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView, forState state: UIControlState) -> NSAttributedString? {
        let str = "HELLO"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView) {
        let alertController = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Hurray", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}
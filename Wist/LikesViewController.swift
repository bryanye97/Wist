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
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension LikesViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likesSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = likesSource[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! LikesCollectionViewCell
        
        
        cell.backgroundColor = UIColor.brownColor()
        
        post.downloadImage()
        cell.emailLabel.text = post.user?.username ?? ""
        cell.post = post
        return cell
    }
}

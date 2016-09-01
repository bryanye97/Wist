//
//  ProfileViewController.swift
//  Wist
//
//  Created by Bryan Ye on 30/06/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var postsByCurrentUser = [Post]()
    
//    var photoTakingHelper: PhotoTakingHelper?
    
//    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.imageTapped))
//        profilePictureImageView.userInteractionEnabled = true
//        profilePictureImageView.addGestureRecognizer(tapGestureRecognizer)
        
        usernameLabel.text = PFUser.currentUser()?.username
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseHelper.postsByCurrentUser { (result: [PFObject]?, error: NSError?) in
            guard let result = result else { return }
            self.postsByCurrentUser = result as? [Post] ?? []
            self.tableView.reloadData()
            
        }
    }
    
//    func imageTapped() {
//        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
//            self.profilePictureImageView.image = image
//        })
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func listNewBookButton(sender: UIButton) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = postsByCurrentUser[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ProfileTableViewCell
        cell.post = post
        post.downloadImage()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsByCurrentUser.count
    }
}
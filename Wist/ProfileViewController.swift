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
    
//    var photoTakingHelper: PhotoTakingHelper?
    
//    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.imageTapped))
//        profilePictureImageView.userInteractionEnabled = true
//        profilePictureImageView.addGestureRecognizer(tapGestureRecognizer)
        
        usernameLabel.text = PFUser.currentUser()?.username
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
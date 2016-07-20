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
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            bookTitleLabel.text = stringToBoldAndSpacedFormat(post.bookName!)
            bookImageView.image = post.image.value
            usernameLabel.text = post.user?.username
            emailLabel.text = post.user?.email
            conditionLabel.text = post.bookCondition
            genreLabel.text = post.bookGenre
            priceLabel.text = post.bookPrice
        }
        
    }
    
    func stringToBoldAndSpacedFormat(string: String) -> String {
        let upperCaseString = string.uppercaseString

        let string = String(
            upperCaseString.characters.enumerate().map() {
                [$0.element, " "]
                }.flatten())
        return string
    }
    
    @IBAction func unlikePost(sender: UIButton) {
        if let post = post {
            ParseHelper.unlikePost(PFUser.currentUser()!, post: post)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

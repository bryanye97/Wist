//
//  BookInformationViewController.swift
//  Wist
//
//  Created by Bryan Ye on 14/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class BookInformationViewController: UIViewController {
    
    var post: Post?
    
    @IBOutlet weak var bookImageView: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            bookImageView.image = post.image.value
            usernameLabel.text = post.user?.username
            emailLabel.text = post.user?.email
            conditionLabel.text = post.bookCondition
            genreLabel.text = post.bookGenre
            priceLabel.text = post.bookPrice
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

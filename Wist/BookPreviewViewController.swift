//
//  BookPreviewViewController.swift
//  Wist
//
//  Created by Bryan Ye on 23/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse

class BookPreviewViewController: UIViewController {

    var post: Post?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            bookTitleLabel.text = post.bookName
            bookImageView.image = post.image.value
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
    
    @IBAction func flagButtonTapped(sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        alertController.view.tintColor = .blackColor()
        
        let reportAction = UIAlertAction(title: "Report Content", style: .Default) { (action) in
            self.post?.flagPost(PFUser.currentUser()!)
        }
        alertController.addAction(reportAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

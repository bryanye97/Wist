//
//  BookCardView.swift
//
//
//  Created by Bryan Ye on 1/07/2016.
//
//

import UIKit
import Parse
import Bond

class BookCardView: UIView {
    
    var shadowLayer: CAShapeLayer!

    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var postDisposable: DisposableType?
    var likeDisposable: DisposableType?
    
    var post: Post? {
        didSet {
            
            postDisposable?.dispose()
            likeDisposable?.dispose()
            
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                bookNameLabel.text = post.bookName
                priceLabel.text = post.bookPrice
                
                postDisposable = post.image.bindTo(bookImageView.bnd_image)
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                }
            }
        }
    }
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayBorder().CGColor
        self.layer.masksToBounds = true
    }
    

//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        
//        let saveAction = UIAlertAction(title: "Save item", style: .Default) { (action) in
//        }
//        alertController.addAction(saveAction)
//        
//        let messageAction = UIAlertAction(title: "Message seller", style: .Default) { (action) in
//            
//        }
//        alertController.addAction(messageAction)
//        
//        
//        
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
    
}

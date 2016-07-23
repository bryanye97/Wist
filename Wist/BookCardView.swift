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
    
    @IBOutlet weak var bookConditionLabel: UILabel!
    
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
                bookConditionLabel.text = post.bookCondition
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
}

//
//  ProfileTableViewCell.swift
//  Wist
//
//  Created by Bryan Ye on 9/08/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Bond
import ConvenienceKit
import Parse

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    
    var postDisposable: DisposableType?
    
    var post: Post? {
        didSet {
            
            postDisposable?.dispose()
            
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                
                postDisposable = post.image.bindTo(bookImageView.bnd_image)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

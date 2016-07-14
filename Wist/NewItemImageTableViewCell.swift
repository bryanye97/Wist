//
//  NewItemImageTableViewCell.swift
//  Wist
//
//  Created by Bryan Ye on 13/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

protocol NewItemImageTableViewCellDelegate {
    func takePicture()
}

class NewItemImageTableViewCell: UITableViewCell {
    
    var delegate: NewItemImageTableViewCellDelegate?
    
    @IBOutlet weak var newItemBookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.imageTapped))
        newItemBookImage.userInteractionEnabled = true
        newItemBookImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped() {
        delegate?.takePicture()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//
//  DesignHelper.swift
//  Wist
//
//  Created by Bryan Ye on 18/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

func squareImage(image: UIImage) -> UIImage {
    let originalWidth  = image.size.width
    let originalHeight = image.size.height
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var edge: CGFloat = 0.0
    
    if (originalWidth > originalHeight) {
        edge = originalHeight
        x = (originalWidth - edge) / 2.0
        y = 0.0
        
    } else if (originalHeight > originalWidth) {
        edge = originalWidth
        x = 0.0
        y = (originalHeight - originalWidth) / 2.0
    } else {
        edge = originalWidth
    }
    
    let cropSquare = CGRectMake(x, y, edge, edge)
    let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
    
    return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
}

extension UIView {
    func addBorderAndRadiusToView(borderWidth: Double, cornerRadius: CGFloat) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
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



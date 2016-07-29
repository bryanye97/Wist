//
//  CustomLabel.swift
//  Wist
//
//  Created by Bryan Ye on 28/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    let topInset = CGFloat(8.0), bottomInset = CGFloat(8.0), leftInset = CGFloat(8.0), rightInset = CGFloat(8.0)
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }

}

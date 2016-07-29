//
//  WistSignUpViewController.swift
//  Wist
//
//  Created by Bryan Ye on 22/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class WistSignUpViewController: PFSignUpViewController {
    
    var backgroundImage : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView(image: UIImage(named: "wistBackground"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        signUpView!.insertSubview(backgroundImage, atIndex: 0)
        
        
        let logo = UILabel()
        logo.text = "Wist"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "helveticaneue", size: 70)
        signUpView?.logo = logo
        
        signUpView?.signUpButton!.setBackgroundImage(nil, forState: .Normal)
        signUpView?.signUpButton!.backgroundColor = UIColor.wistPurpleColor()
        
        signUpView?.dismissButton!.setTitle("Already signed up?", forState: .Normal)
        signUpView?.dismissButton!.setImage(nil, forState: .Normal)

        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.frame = CGRectMake( 0,  0,  signUpView!.frame.width,  signUpView!.frame.height)
        
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRectMake(logoFrame.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, signUpView!.frame.width,  logoFrame.height)
        
        let dismissButtonFrame = signUpView!.dismissButton!.frame
        signUpView?.dismissButton!.frame = CGRectMake(0, signUpView!.signUpButton!.frame.origin.y + signUpView!.signUpButton!.frame.height + 16.0,  signUpView!.frame.width,  dismissButtonFrame.height)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

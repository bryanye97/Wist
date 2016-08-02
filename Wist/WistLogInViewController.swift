//
//  WistLogInViewController.swift
//  Wist
//
//  Created by Bryan Ye on 22/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class WistLogInViewController: PFLogInViewController {
    
    var backgroundImage : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpController = WistSignUpViewController()
        self.signUpController?.loadViewIfNeeded()
        self.signUpController!.delegate = self
        
        backgroundImage = UIImageView(image: UIImage(named: "wistBackground"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.logInView!.insertSubview(backgroundImage, atIndex: 0)
        
        let logo = UILabel()
        logo.text = "Wist"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "helveticaneue", size: 70)
        logInView?.logo = logo
        
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
        logInView?.logInButton?.backgroundColor = UIColor.wistPurpleColor()
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        // just for now
        logInView?.facebookButton?.hidden = true
        
        customizeButton(logInView?.facebookButton!)
        customizeButton(logInView?.signUpButton!)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
        backgroundImage.frame = CGRectMake(0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension WistLogInViewController: PFSignUpViewControllerDelegate {
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

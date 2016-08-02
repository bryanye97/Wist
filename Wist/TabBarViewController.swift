//
//  TabBarViewController.swift
//  Wist
//
//  Created by Bryan Ye on 29/06/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        let statusBarHeight = statusBarSize.height
        self.tabBar.frame = CGRectMake(0,statusBarHeight,screenSize.width,50)
        
        self.tabBar.itemPositioning = UITabBarItemPositioning.Centered
        
        self.tabBar.layer.addBorder(.Bottom, color: .lightGrayBorder(), thickness: 1.5)
        
        self.tabBar.clipsToBounds = true
    }
}

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
        
        self.tabBar.frame = CGRectMake(0,statusBarHeight,screenSize.width,50);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

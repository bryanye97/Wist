//
//  AppDelegate.swift
//  Wist
//
//  Created by Bryan Ye on 29/06/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4
import Firebase
import FirebaseDatabase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var parseLoginHelper: ParseLoginHelper!
    
    var window: UIWindow?
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            
            if let error = error {
                
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
                
                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
            }
        }
    }
    
//    func addMessage(chatroomRef: FIRDatabaseReference, sender: String, message: String) {
//        chatroomRef.childByAutoId().setValue(createMessagingDictionary(sender, message: message))
//    }
//    
//    func createMessagingDictionary(sender: String, message: String) -> [String: AnyObject] {
//         return ["sender": sender, "message": message, "date": NSDate().timeIntervalSince1970]
//    }
//    
//    func createNewChatroom(rootRef: FIRDatabaseReference) -> FIRDatabaseReference {
//        let chatroomRef = rootRef.child("Messaging").childByAutoId()
//        return chatroomRef
//    }
    
    func firebaseTest() {
//        let ref = FIRDatabase.database().reference()
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
//            print(user)
//            print(error)
//            let newChatRoom = self.createNewChatroom(ref)
//            let chatroomKey = newChatRoom.key
////            createChatroomInParse(chatroomKey)
//            for (i,value) in ["hello", "1321321", "32312312312312312312312", "tim31321321o", "timooooo", "teeemo"].enumerate() {
//                
//                let userArray = ["timo", "eura"]
//                self.addMessage(newChatRoom, sender: userArray[i%2], message: value)
//                
//            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
    
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
        
        FIRApp.configure()
        
       
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (user, error) in
            print(user)
            print(error)
        })
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "Wist"
            $0.server = "https://wist-parse-by.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        

        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController
        
        if (user != nil) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        } else {
            
            let loginViewController = WistLogInViewController()
            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
            loginViewController.delegate = parseLoginHelper
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.emailAsUsername = true
            
            startViewController = loginViewController
        }
        
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        let acl = PFACL()
        acl.publicReadAccess = true
        acl.publicWriteAccess = true
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


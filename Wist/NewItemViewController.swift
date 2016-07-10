//
//  NewItemViewController.swift
//  Wist
//
//  Created by Bryan Ye on 30/06/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {
    
    let post = Post()
    
    var photoTakingHelper: PhotoTakingHelper?

    @IBOutlet weak var bookNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func uploadBookImageButton(sender: AnyObject) {

        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.post.image.value = image
        })
    }
    
    @IBAction func confirmBook(sender: UIButton) {
        self.post.bookName = bookNameTextField.text
        self.post.uploadPost()
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


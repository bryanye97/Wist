//
//  TestViewController.swift
//  Wist
//
//  Created by Bryan Ye on 13/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let defaultTableViewCellSize: CGFloat = 44
    let imageTableViewCellSize: CGFloat = 250
    let numberOfRowsInImageSection = 1
    let numberOfRowsInTextFieldSection = 3
    
    var photoTakingHelper: PhotoTakingHelper?
    
    let post = Post()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBook(sender: UIButton) {
        let bookNameIndexPath = NSIndexPath.init(forRow: 0, inSection: 1)
        let bookNameCell = tableView.cellForRowAtIndexPath(bookNameIndexPath) as! NewItemTextFieldTableViewCell
        post.bookName = bookNameCell.textField.text
        print(post.bookName)
        
        let bookConditionIndexPath = NSIndexPath.init(forRow: 1, inSection: 1)
        let bookConditionCell = tableView.cellForRowAtIndexPath(bookConditionIndexPath) as! NewItemTextFieldTableViewCell
        post.bookCondition = bookConditionCell.textField.text
        print(post.bookCondition)
        
        let bookGenreIndexPath = NSIndexPath.init(forRow: 2, inSection: 1)
        let bookGenreCell = tableView.cellForRowAtIndexPath(bookGenreIndexPath) as! NewItemTextFieldTableViewCell
        post.bookGenre = bookGenreCell.textField.text
        print(post.bookGenre)
        
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

extension TestViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return imageTableViewCellSize
        } else {
            return defaultTableViewCellSize
        }
    }
}

extension TestViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("newItemImageCell") as! NewItemImageTableViewCell
            cell.delegate = self
            cell.newItemBookImage.image = post.image.value
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("newItemTextCell") as! NewItemTextFieldTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.textField.placeholder = "Book name"
            case 1:
                cell.textField.placeholder = "Condition"
            case 2:
                cell.textField.placeholder = "Genre"
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return numberOfRowsInImageSection
        case 1:
            return numberOfRowsInTextFieldSection
        default:
            return 0
        }
    }
}

extension TestViewController: NewItemImageTableViewCellDelegate {
    func takePicture() {
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.post.image.value = image
            self.tableView.reloadData()
        })
        
    }
}
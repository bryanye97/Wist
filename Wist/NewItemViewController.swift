//
//  NewItemViewController.swift
//  Wist
//
//  Created by Bryan Ye on 13/07/2016.
//  Copyright © 2016 Bryan Ye. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaultTableViewCellSize: CGFloat = 44
    let imageTableViewCellSize: CGFloat = 250
    let numberOfRowsInImageSection = 1
    let numberOfRowsInTextFieldSection = 4
    
    var photoTakingHelper: PhotoTakingHelper?
    
    let post = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func submitBook(sender: UIButton) {
        let bookNameIndexPath = NSIndexPath.init(forRow: 0, inSection: 1)
        let bookNameCell = tableView.cellForRowAtIndexPath(bookNameIndexPath) as! NewItemTextFieldTableViewCell
        post.bookName = bookNameCell.textField.text

        let bookConditionIndexPath = NSIndexPath.init(forRow: 1, inSection: 1)
        let bookConditionCell = tableView.cellForRowAtIndexPath(bookConditionIndexPath) as! NewItemTextFieldTableViewCell
        post.bookCondition = bookConditionCell.textField.text

        let bookGenreIndexPath = NSIndexPath.init(forRow: 2, inSection: 1)
        let bookGenreCell = tableView.cellForRowAtIndexPath(bookGenreIndexPath) as! NewItemTextFieldTableViewCell
        post.bookGenre = bookGenreCell.textField.text

        let bookPriceIndexPath = NSIndexPath.init(forRow: 3, inSection: 1)
        let bookPriceCell = tableView.cellForRowAtIndexPath(bookPriceIndexPath) as! NewItemTextFieldTableViewCell
        post.bookPrice = "$" + bookPriceCell.textField.text! ?? ""
        
        self.post.uploadPost()
    }
}

extension NewItemViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return imageTableViewCellSize
        } else {
            return defaultTableViewCellSize
        }
    }
}

extension NewItemViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("newItemImageCell") as! NewItemImageTableViewCell
            cell.delegate = self
            if post.image.value != nil {
                cell.newItemBookImage.image = post.image.value
            } else {
                cell.newItemBookImage.image = UIImage(named: "click_to_add_an_image")
            }
            
            
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
            case 3:
                cell.textField.placeholder = "Price"
                cell.textField.keyboardType = UIKeyboardType.DecimalPad
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

extension NewItemViewController: NewItemImageTableViewCellDelegate {
    func takePicture() {
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.post.image.value = image
            self.tableView.reloadData()
        })
    }
}
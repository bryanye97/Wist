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
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.tableView.dataSource = self
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

extension TestViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("newItemImage") as! NewItemImageTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("newItemText") as! NewItemTextFieldTableViewCell
            
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
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
}

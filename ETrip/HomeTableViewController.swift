//
//  HomeTableViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit

class HomeTableViewController: UITableViewController {
    
    var posts = [Post]()
    //    var postDictionary = [String: Post]()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sideMenu set up
        
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        // reload data from Firebase
        databaseRef.child("posts").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let postID = snapshot.key
            let title = snapshot.value!["title"] as! String
            let country = snapshot.value!["country"] as! String
            let startDate = snapshot.value!["startDate"] as! String
            let returnDate = snapshot.value!["returnDate"] as! String
            
            // print("aaaaahhhhhhhh: \(snapshot)")
            
            
            self.posts.append(Post(postID: postID, title: title, country: country, startDate: startDate, returnDate: returnDate))
            print(self.posts.count)
            print("ssssssssssssss:\(postID)")
            self.tableView.reloadData()
            
            
        })
        
        databaseRef.child("posts").observeEventType(.ChildChanged, withBlock: { (snapshot) in
            
            print(snapshot.key)
            
            //            self.postDictionary.removeValueForKey(snapshot.key)
            self.tableView.reloadData()
            
            }, withCancelBlock: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "HomeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.countryLabel.text = post.country
        cell.startDateLabel.text = post.startDate
        cell.returnDateLabel.text = post.returnDate
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let postID = posts[indexPath.row].postID
            
            databaseRef.child("posts").child(postID).removeValue()
            
            
            self.posts.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            
            print("\(indexPath.row) ssssssss: \(postID)")
            
            
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        if segue.identifier == "showDetailSegue" {
        //            let detailViewController = segue.destinationViewController as! EditViewController
        //
        //            // Get the cell that generated this segue.
        //            if let selectedCell = sender as? HomeTableViewCell {
        //                let indexPath = tableView.indexPathForCell(selectedCell)!
        //                let selectedPost = posts[indexPath.row]
        //                detailViewController.post = selectedPost
        //
        //                print("Editing post.")
        //            }
        //        }
        //        else
        if segue.identifier == "addPostSegue" {
            print("Adding new post.")
        }
    }
    
    @IBAction func unwindToHomePage(sender: UIStoryboardSegue) { }
    
    
    
    
    
    
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

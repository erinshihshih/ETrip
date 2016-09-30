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
    
    @IBAction func logoutButton(sender: AnyObject) {
        
        // sign the user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        // sign the user out of the facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        // move the user to the login page
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController
        //                self.presentViewController(homeTableViewController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("posts").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let title = snapshot.value!["title"] as! String
            let destination = snapshot.value!["destination"] as! String
            
            self.posts.insert(Post(title: title, destination: destination), atIndex: 0)
            self.tableView.reloadData()
        })
        
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
        cell.destinationLabel.text = "Destination: \(post.destination)"

        
        return cell
    }
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetailSegue" {
//            let detailViewController = segue.destinationViewController as! ResultViewController
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
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

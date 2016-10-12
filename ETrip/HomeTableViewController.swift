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
    var transportations = [Transportation]()
    
    
    
    //    var postDictionary = [String: Post]()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sideMenu set up
        
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        // reload data from Firebase
        databaseRef.child("posts").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            //            print("snapShotValue: \(snapshot.value)")
            //            if let postDict = snapshot.value as? [String:AnyObject] {
            //                for each in postDict as [String: AnyObject] {
            //                    let item = each.0
            //                    print("autoID: \(item)")
            //
            //                }
            //            }
            
            let posts = snapshot.value! as! [String : AnyObject]
            
            let postID = snapshot.key
            let title = posts["title"] as! String
            let country = posts["country"] as! String
            let startDate = posts["startDate"] as! String
            let returnDate = posts["returnDate"] as! String
            
            self.posts.append(Post(postID: postID, title: title, country: country, startDate: startDate, returnDate: returnDate))
            
            self.tableView.reloadData()
            
        })
        
//        databaseRef.child("transportations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
//            snapshot in
//            
//            let posts = snapshot.value! as! [String : AnyObject]
//            
//            
//            let postID = posts["postID"] as! String
//            let type = posts["type"] as! String
//            let departDate = posts["departDate"] as! String
//            let arriveDate = posts["arriveDate"] as! String
//            let departFrom = posts["departFrom"] as! String
//            let arriveAt = posts["arriveAt"] as! String
//            let airlineCom = posts["airlineCom"] as! String
//            let flightNo = posts["flightNo"] as! String
//            let bookingRef = posts["bookingRef"] as! String
//            
//            self.transportations.append(Transportation(postID: postID, type: type, departDate: departDate, arriveDate: arriveDate, departFrom: departFrom, arriveAt: arriveAt, airlineCom: airlineCom, flightNo: flightNo, bookingRef: bookingRef))
//            
//            self.tableView.reloadData()
//        })
//        
        
        
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
            
            // Delete Post
            databaseRef.child("posts").child(postID).removeValue()
            
            // Delete Transportations
            databaseRef.child("transportations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                let transportationsPostID = snapshot.value!["postID"] as! String
                let transportationID = snapshot.key
                if transportationsPostID == postID {
                    self.databaseRef.child("transportations").child(transportationID).removeValue()
                }
            })
            
            // Delete Attractions
            databaseRef.child("attractions").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                let attractionsPostID = snapshot.value!["postID"] as! String
                let attractionID = snapshot.key
                if attractionsPostID == postID {
                    self.databaseRef.child("attractions").child(attractionID).removeValue()
                }
            })
            
            // Remove From Table View
            self.posts.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                if segue.identifier == "showDetailSegue" {
                    let detailViewController = segue.destinationViewController as! EditViewController
        
                    // Get the cell that generated this segue.
                    if let selectedCell = sender as? HomeTableViewCell {
                        let indexPath = tableView.indexPathForCell(selectedCell)!
                        
                        let selectedPost = posts[indexPath.row]
                        detailViewController.post = selectedPost
        
                        print("Editing post.")
                    }
                }
                else
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

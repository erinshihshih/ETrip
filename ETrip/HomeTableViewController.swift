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
    
    // MARK: Property
    var posts = [Post]()
    var deletePostIndexPath: NSIndexPath? = nil
    
    let databaseRef = FIRDatabase.database().reference()
    
    var pullToRefreshControl: UIRefreshControl!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Manager Delegate
        FirebaseManager.shared.delegate = self
//        FirebaseManager.shared.fetchPosts()
        
        // sideMenu set up
        
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        //        let a =  amyStartDate!.sortInPlace({$0 < $1})
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "CourierNewPS-BoldMT", size: 20)!], forState: UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
        
        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
            kFIRParameterContentType: (FIRAuth.auth()?.currentUser?.displayName)!,
            kFIRParameterItemID: "user_name"
            ])
        
       
    
        pullToRefresh()
        
    }
    
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated)
        
        posts = []
        
        FirebaseManager.shared.delegate = self
       
        FirebaseManager.shared.fetchPosts()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Function
    
    func pullToRefresh() {
        
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullToRefreshControl.addTarget(self, action: #selector(HomeTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Setup UI
        
        pullToRefreshControl.tintColor = UIColor(red: 182/255, green: 212/255, blue: 242/255, alpha: 1)
        
        let attributes = [NSForegroundColorAttributeName: UIColor(red: 182/255, green: 212/255, blue: 242/255, alpha: 1), NSFontAttributeName : UIFont(name: "CourierNewPSMT", size: 20)!]
        
        let attributedTitle = NSAttributedString(string: "pull to refresh", attributes: attributes)
        
        pullToRefreshControl.attributedTitle = attributedTitle
        
        tableView.addSubview(pullToRefreshControl)
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        posts = []
        
        FirebaseManager.shared.delegate = self
        
        FirebaseManager.shared.fetchPosts()
        pullToRefreshControl.endRefreshing()
        
    }
    
    
    // MARK: - UITableViewDataSource
    
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
            
            deletePostIndexPath = indexPath
            let postTitle = posts[indexPath.row].title
            confirmDelete(postTitle)
            
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSegue" {
            let detailViewController = segue.destinationViewController as! ResultViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? HomeTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                
                if posts.count >= 1 {
                let selectedPost = posts[indexPath.row]
                detailViewController.post = selectedPost
                
                } else { return }
                
                print("Show the trip result.")
            }
        }
        else if segue.identifier == "addPostSegue" {
            print("Adding new post.")
        }
    }
    
    @IBAction func unwindToHomePage(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? AddViewController, post = sourceViewController.post {
            
            // Add a new meal.
            posts.append(post)
            posts.sortInPlace { $0.startDate.stringToDouble() > $1.startDate.stringToDouble() }
            tableView.reloadData()

            
        }
    
    }
    
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
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }
    
    // Delete post and show alert
    func confirmDelete(post: String) {
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to permanently delete \(post)?", preferredStyle: .Alert)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePost)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePost)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeletePost(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePostIndexPath {
            
            tableView.beginUpdates()
            
            let postID = posts[indexPath.row].postID
            
            // Delete Post from Firebase
            databaseRef.child("posts").child(postID).removeValue()
            
            // Delete Transportations from Firebase
            databaseRef.child("transportations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                let transportationsPostID = snapshot.value!["postID"] as! String
                let transportationID = snapshot.key
                if transportationsPostID == postID {
                    self.databaseRef.child("transportations").child(transportationID).removeValue()
                }
            })
            
            // Delete Attractions from Firebase
            databaseRef.child("attractions").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                let attractionsPostID = snapshot.value!["postID"] as! String
                let attractionID = snapshot.key
                if attractionsPostID == postID {
                    self.databaseRef.child("attractions").child(attractionID).removeValue()
                }
            })
            
            // Delete Accommodations from Firebase
            databaseRef.child("accommodations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                let accommodationsPostID = snapshot.value!["postID"] as! String
                let accommodationID = snapshot.key
                if accommodationsPostID == postID {
                    self.databaseRef.child("accommodations").child(accommodationID).removeValue()
                }
            })

            
            // Remove From Table View
            self.posts.removeAtIndex(indexPath.row)
            //            self.tableView.reloadData()
            
            // indexPath is wrapped in an array: [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            deletePostIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePost(alertAction: UIAlertAction!) {
        deletePostIndexPath = nil
    }
    
    
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

extension HomeTableViewController: FirebaseManagerDelegate {
    
    func getPostManager(getPostManager: FirebaseManager, didGetData post: Post) {
        
        self.posts.append(post)
        
        posts.sortInPlace { $0.startDate.stringToDouble() > $1.startDate.stringToDouble() }
        
        self.tableView.reloadData()
        
    }
    
    func getTransportationManager(getTransportationManager: FirebaseManager, didGetData transportation: Transportation) {
        
    }
    
    func getAttractionManager(getAttractionManager: FirebaseManager, didGetData attraction: Attraction) {
        
    }
    
    func getAccommodationManager(getAccommodationManager: FirebaseManager, didGetData attraction: Accommodation) {
        
    }
    
}

extension NSString {
    func stringToDouble() -> Double {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMMdd, yyyy HH:mm"
        
        let date = dateFormatter.dateFromString(self as String)
        return date!.timeIntervalSince1970
    }
}



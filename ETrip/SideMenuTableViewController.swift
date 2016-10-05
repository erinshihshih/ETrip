//
//  SideMenuTableViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/3.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FBSDKCoreKit

class SideMenuTableViewController: UITableViewController {
    
    var items = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SideMenuTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SideMenuTableViewCell
        
//        let item = items[indexPath.row]
        
        cell.profileImage.layer.cornerRadius =  cell.profileImage.frame.size.width / 2
        
        cell.profileImage.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            let name = user.displayName
            // let email = user.email
//            let photoUrl = user.photoURL
            // let uid = user.uid
            
            cell.nameLabel.text = name
            
            // 儲存圖像至firebase
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://etrip-fb2ab.appspot.com")
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if error != nil {
                    
                    print("Unable to download image")
                    
                } else {
                    
                    if data != nil {
                        
                        print("User already has an image, no need to download from Facebook")
                        cell.profileImage.image = UIImage(data: data!)
                        
                    }
                }
            }
            
            if cell.profileImage.image == nil{
                
                let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300, "redirect": false], HTTPMethod: "GET")
                profilePic.startWithCompletionHandler({(connection, result, error)-> Void in
                    
                    if error == nil {
                        let dictionary = result as? NSDictionary
                        let data = dictionary?.objectForKey("data")
                        
                        let urlPic = (data?.objectForKey("url"))! as! String
                        
                        if let imageData = NSData(contentsOfURL: NSURL(string: urlPic)!){
                            
                            let uploadTask = profilePicRef.putData(imageData, metadata: nil) {
                                metadata, error in
                                
                                if error == nil{
                                    let downloadUrl = metadata!.downloadURL
                                }
                                    
                                else {
                                    print("Error in downloading image")
                                }
                            }
                            
                            cell.profileImage.image = UIImage(data: imageData)
                        }
                    }
                    
                })
                
            }
            
        } else {
            // No user is signed in.
        }
        
        
        
        
        
        return cell
    }
    
    
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

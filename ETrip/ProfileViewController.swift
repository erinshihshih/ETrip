//
//  ProfileViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/3.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
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
    //    @IBAction func logoutButton(sender: AnyObject) {
    //
    
    //
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        
        self.profileImage.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            let name = user.displayName
            //            let email = user.email
            let photoUrl = user.photoURL
            //            let uid = user.uid
            
            self.nameLabel.text = name
            
            //            let data = NSData(contentsOfURL: photoUrl!)
            //            self.profileImage.image = UIImage(data:data!)
            
            
            // 儲存圖像至firebase
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://etrip-fb2ab.appspot.com")
            
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    
                    print("Unable to download image")
                } else {
                    
                    if data != nil {
                        
                        print("User already has an image, no need to download from Facebook")
                        self.profileImage.image = UIImage(data: data!)
                    }
                }
            }
            
            if self.profileImage.image == nil{
                
                
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
                            
                            self.profileImage.image = UIImage(data: imageData)
                        }
                    }
                    
                })
                
            }
            
        } else {
            // No user is signed in.
        }
        
        
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

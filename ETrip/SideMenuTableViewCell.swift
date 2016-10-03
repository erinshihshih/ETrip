//
//  SideMenuTableViewCell.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/3.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit

class SideMenuTableViewCell: UITableViewCell {

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
        
    }
   
}

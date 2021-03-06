//
//  ViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/26.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
//    let loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.frame = CGRect(x: view.frame.width/4, y: view.frame.height - 200, width: view.frame.width/2, height: 40)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if user != nil {
                
                // User is signed in and move to the home page
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                // HomeNavigationController
                //                let homeNavigationController = storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
                //
                //                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                //                appDelegate.window?.rootViewController = homeNavigationController
                
                // RevealViewController
                let revealViewController = storyboard.instantiateViewControllerWithIdentifier("RevealViewController")
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = revealViewController
                
                
            } else {
                
                // No user is signed in and show the login button
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                
                
                
                self.view.addSubview(self.loginButton)
                
            }
        }
        
     
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        // Creat a reference to Firebase
        let databaseRef = FIRDatabase.database().reference()
        
        print("User Logged In")
        
        if error != nil {
            
            print("Error :  \(error.description)")
            
        } else if result.isCancelled {
            
            print("Login is cancelled")
            
        } else {
            
            // login to Firebasee
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { user, error in
                
                print("User Logged In to Firebase App")
                
                if let user = FIRAuth.auth()?.currentUser {
                    
                    for profile in user.providerData {
                        
                        //                        let providerUid = profile.uid
                        //                        let providerID = profile.providerID
                        let name = profile.displayName
                        let email = profile.email
                        let profilePicURL = profile.photoURL
                        
                        let newUser: [String: AnyObject] = [
                            //                            "providerID": providerID, // 管理不同的第三方登入
                            "name": name!,
                            "email": email!,
                            "profilePicURL": "\(profilePicURL!)"]
                        
                        databaseRef.child("users").child(user.uid).setValue(newUser)
                        
                        FIRAnalytics.logEventWithName("newUserLogin", parameters: ["name": user.uid])
                        
                    }
                    
                } else {
                    
                    print("No user is signed in.")
                    
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("User did Logout")
        
    }
}


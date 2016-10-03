//
//  ViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/26.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.hidden = true
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                // move the user to the home page
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                // HomeNavigationController
//                let homeNavigationController = storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
//
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                appDelegate.window?.rootViewController = homeNavigationController
                
                // test ProfileViewController
                let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = profileViewController
                
                
            } else {
                // No user is signed in.
                // show the user the login button
                
                // set up FB login button
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.view.addSubview(self.loginButton)
                
                self.loginButton.hidden = false
            }
        }
        
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        self.loginButton.hidden = true
        
        if  error != nil {
            
            self.loginButton.hidden = false
            
            print("Error :  \(error.description)")
        

        }else if result.isCancelled {
            
            self.loginButton.hidden = false
            
            print("Login is cancelled")
            
        } else {
            
            // login to firebasee
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("User Logged In to Firebase App")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User did Logout")
    }
    
}


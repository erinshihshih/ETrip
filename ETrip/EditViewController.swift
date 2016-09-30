//
//  EditViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var post: Post?
  
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        
        let isPresentingInAddPostMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPostMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleTextField.delegate = self
        destinationTextField.delegate = self
        
        if let post = post {
            titleTextField.text = post.title
            destinationTextField.text = post.destination
        }
        
      
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            let title = titleTextField.text ?? ""
            let destination = destinationTextField.text ?? ""
            
            // Store in Firebase
         
            let postOnFire: [String: AnyObject] = [ "title": title,
                                                    "destination": destination ]
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("posts").childByAutoId().setValue(postOnFire)
            
            // Set the post to be passed to HomeTableViewController after the unwind segue.
            post = Post(title: title, destination: destination)
        }
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

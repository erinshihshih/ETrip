//
//  FirebaseManager.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/13.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol FirebaseManagerDelegate: class {
    
    func getPostManager(getPostManager: FirebaseManager, didGetData posts: [Post])
    
}

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    weak var delegate: FirebaseManagerDelegate?
    
    var posts: [Post] = []
    
    func fetchPosts() {
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("posts").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let posts = snapshot.value! as! [String : AnyObject]
            
            let postID = snapshot.key
            let title = posts["title"] as! String
            let country = posts["country"] as! String
            let startDate = posts["startDate"] as! String
            let returnDate = posts["returnDate"] as! String
            
            self.posts.append(Post(postID: postID, title: title, country: country, startDate: startDate, returnDate: returnDate))
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.delegate?.getPostManager(self, didGetData: self.posts)
            
            }
        })
    }
}
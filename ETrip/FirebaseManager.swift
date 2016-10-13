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
    
    func getTransportationManager(getTransportationManager: FirebaseManager, didGetData transportations: Transportation)
    
}

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    weak var delegate: FirebaseManagerDelegate?
    
    let databaseRef = FIRDatabase.database().reference()
    var posts: [Post] = []
    var transportations: [Transportation] = []
    
    func fetchPosts() {
        
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
    
    func fetchTransportations() {
        
        databaseRef.child("transportations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
    
            guard let transportationDict = snapshot.value as? NSDictionary else {
                fatalError()
            }
            
                let postID = transportationDict["postID"] as! String
                let type = transportationDict["type"] as! String
                let airlineCom = transportationDict["airlineCom"] as! String
                let flightNo = transportationDict["flightNo"] as! String
                let bookingRef = transportationDict["bookingRef"] as! String
                let departFrom = transportationDict["departFrom"] as! String
                let arriveAt = transportationDict["arriveAt"] as! String
                let departDate = transportationDict["departDate"] as! String
                let arriveDate = transportationDict["arriveDate"] as! String
                
//                self.transportations.append(Transportation)
            let transportation = Transportation(postID: postID, type: type, departDate: departDate, arriveDate: arriveDate, departFrom: departFrom, arriveAt: arriveAt, airlineCom: airlineCom, flightNo: flightNo, bookingRef: bookingRef)
            
                self.delegate?.getTransportationManager(self, didGetData: transportation)
        
        })
        
    }
    
    
    
    
    
}
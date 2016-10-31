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
    
    func getPostManager(getPostManager: FirebaseManager, didGetData post: Post)
    
    func getTransportationManager(getTransportationManager: FirebaseManager, didGetData transportation: Transportation)
    
    func getAttractionManager(getAttractionManager: FirebaseManager, didGetData attraction: Attraction)
    
    func getAccommodationManager(getAccommodationManager: FirebaseManager, didGetData accommodation: Accommodation)
}

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    weak var delegate: FirebaseManagerDelegate?
    
    let databaseRef = FIRDatabase.database().reference()
    let currentUid = FIRAuth.auth()?.currentUser?.uid
    
    var posts: [Post] = []
    var transportations: [Transportation] = []
    var attractions: [Attraction] = []
    var accommodations: [Accommodation] = []
    
    func fetchPosts() {
        
         databaseRef.child("posts").queryOrderedByChild("uid").queryEqualToValue(currentUid).observeSingleEventOfType(.Value, withBlock: {
        
//        databaseRef.child("posts").queryOrderedByKey().observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.exists() {
                
                
                self.posts = []
                
                for item in [snapshot.value] {
                    
                    guard let itemDictionary = item as? NSDictionary else {
                        fatalError()
                    }
                    
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        fatalError()
                    }
                    
                    guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                        fatalError()
                    }
                    
                    for (index, item) in firebaseItemValue.enumerate() {
                        
//                        let uid = item["uid"] as! String
//                        guard uid == self.currentUid else { return }
                        
                        let postID = firebaseItemKey[index]
                        
                        let title = item["title"] as! String
                        let indexPathRow = item["indexPathRow"] as! Int
                        let country = item["country"] as! String
                        let startDate = item["startDate"] as! String
                        let returnDate = item["returnDate"] as! String
                        
                        let post = Post(postID: postID, indexPathRow: indexPathRow, title: title, country: country, startDate: startDate, returnDate: returnDate)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.delegate?.getPostManager(self, didGetData: post)
                        }
                        
                    }
                }
                
            }
            
            else {
                print("no post")
                return
            }
            
        })
    }
    
    func fetchTransportations() {
        databaseRef.child("transportations").queryOrderedByKey().observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.exists() {
                
                self.transportations = []
                
                for item in [snapshot.value] {
                    
                    guard let itemDictionary = item as? NSDictionary else {
                        fatalError()
                    }
                    
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        fatalError()
                    }
                    
                    guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                        fatalError()
                    }
                    
                    for (index, item) in firebaseItemValue.enumerate() {
                        
                        guard let postID = item["postID"] as? String else { return }
                        
                        let transportationID = item["transportationID"] as! String
                        let indexPathRow = item["indexPathRow"] as! Int
                        let type = item["type"] as! String
                        let airlineCom = item["airlineCom"] as! String
                        let flightNo = item["flightNo"] as! String
                        let bookingRef = item["bookingRef"] as! String
                        let departFrom = item["departFrom"] as! String
                        let arriveAt = item["arriveAt"] as! String
                        let departDate = item["departDate"] as! String
                        let arriveDate = item["arriveDate"] as! String
                        
                        let transportation = Transportation(postID: postID, transportationID: transportationID, indexPathRow: indexPathRow, type: type, departDate: departDate, arriveDate: arriveDate, departFrom: departFrom, arriveAt: arriveAt, airlineCom: airlineCom, flightNo: flightNo, bookingRef: bookingRef)
                        
                        self.delegate?.getTransportationManager(self, didGetData: transportation)
                        
                    }
                }
            }
        })
        
    }
    
    
    func fetchAttractions() {
        databaseRef.child("attractions").queryOrderedByKey().observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.exists() {
                
                self.attractions = []
                
                for item in [snapshot.value] {
                    
                    guard let itemDictionary = item as? NSDictionary else {
                        fatalError()
                    }
                    
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        fatalError()
                    }
                    
                    guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                        fatalError()
                    }
                    
                    for (index, item) in firebaseItemValue.enumerate() {
                        
                        let postID = item["postID"] as! String
                        let attractionID = item["attractionID"] as! String
                        let indexPathRow = item["indexPathRow"] as! Int
                        let name = item["name"] as! String
                        let phone = item["phone"] as! String
                        let address = item["address"] as! String
                        let website = item["website"] as! String
                        
                        let attraction = Attraction(postID: postID, attractionID: attractionID, indexPathRow: indexPathRow, name: name, phone: phone, address: address, website: website)
                        
                        self.delegate?.getAttractionManager(self, didGetData: attraction)

                        
                    }
                }
            }
        })
        
    }
    
    func fetchAccommodations() {
        databaseRef.child("accommodations").queryOrderedByKey().observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.exists() {
                
                self.accommodations = []
                
                for item in [snapshot.value] {
                    
                    guard let itemDictionary = item as? NSDictionary else {
                        fatalError()
                    }
                    
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        fatalError()
                    }
                    
                    guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                        fatalError()
                    }
                    
                    for (index, item) in firebaseItemValue.enumerate() {
                        
                        let postID = item["postID"] as! String
                        let accommodationID = item["accommodationID"] as! String
                        let indexPathRow = item["indexPathRow"] as! Int
                        let name = item["name"] as! String
//                        let phone = item["phone"] as! String
                        let address = item["address"] as! String
                        let checkinDate = item["checkinDate"] as! String
                        let checkoutDate = item["checkoutDate"] as! String
                        let bookingRef = item["bookingRef"] as! String
                        
                        
                        let accommodation = Accommodation(postID: postID, accommodationID: accommodationID, indexPathRow: indexPathRow, name: name, address: address, checkinDate: checkinDate, checkoutDate: checkoutDate, bookingRef: bookingRef)
                        
                        self.delegate?.getAccommodationManager(self, didGetData: accommodation)
                        
                        
                    }
                }
            }
        })
        
    }
    
    
    
}
//
//  Accommodation.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/26.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import Foundation

// Accommodation: 旅店名字, 入住時間, 離開時間, 地址, booking ref.

class Accommodation {
    
    let postID: String
    let name: String
    let checkinDate: NSDate
    let checkoutDate: NSDate
    let address: String
    let bookingRef: String
    
    init(postID: String, name: String, checkinDate: NSDate, checkoutDate: NSDate, address: String, bookingRef: String) {
        
        self.postID = postID
        self.name = name
        self.checkinDate = checkinDate
        self.checkoutDate = checkoutDate
        self.address = address
        self.bookingRef = bookingRef
        
    }
    
}


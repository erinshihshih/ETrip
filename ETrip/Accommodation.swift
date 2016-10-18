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
    let accommodationID: String
    let indexPathRow: Int
    let name: String
    let address: String
    let checkinDate: String
    let checkoutDate: String
    let bookingRef: String
    let note: String
    
    init(postID: String, accommodationID: String, indexPathRow: Int, name: String, address: String, checkinDate: String, checkoutDate: String, bookingRef: String, note: String) {
        
        self.postID = postID
        self.accommodationID = accommodationID
        self.indexPathRow = indexPathRow
        self.name = name
        self.checkinDate = checkinDate
        self.checkoutDate = checkoutDate
        self.address = address
        self.bookingRef = bookingRef
        self.note = note
        
    }
    
}


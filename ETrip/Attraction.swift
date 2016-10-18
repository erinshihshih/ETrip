//
//  Attraction.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/26.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import Foundation

// Attraction: 景點名字, 停留時間, 地址

class Attraction {
    
    let postID: String
    let attractionID: String
    let indexPathRow: Int
    let name: String
    let stayHour: String
    let address: String
    let note: String
    
    init(postID: String, attractionID: String, indexPathRow: Int, name: String, stayHour: String, address: String, note: String) {
        
        self.postID = postID
        self.attractionID = attractionID
        self.indexPathRow = indexPathRow
        self.name = name
        self.stayHour = stayHour
        self.address = address
        self.note = note
        
    }
    
}

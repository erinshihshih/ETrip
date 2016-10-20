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
    let phone: String
    let address: String
    let website: String
    
    init(postID: String, attractionID: String, indexPathRow: Int, name: String, phone: String, address: String, website: String) {
        
        self.postID = postID
        self.attractionID = attractionID
        self.indexPathRow = indexPathRow
        self.name = name
        self.phone = phone
        self.address = address
        self.website = website
        
    }
    
}

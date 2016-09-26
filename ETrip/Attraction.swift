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
    
    let name: String
    let stayHour: Double
    let address: String
    
    init(name: String, stayHour: Double, address: String) {
        
        self.name = name
        self.stayHour = stayHour
        self.address = address
        
    }
    
}

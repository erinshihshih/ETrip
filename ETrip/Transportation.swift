//
//  Transportation.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/26.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import Foundation

// Transportation: 種類, 出發時間, 抵達時間, 出發地點, 抵達地點, airline company, Flight/Train No., booking ref.

class Transportation {
    
    let type: String
    let departDate: NSDate
    let arriveDate: NSDate
    let departPort: String
    let arrivePort: String
    let airlineCom: String
    let infoNo: String
    let bookingRef: String
    
    init(type: String, departDate: NSDate, arriveDate: NSDate, departPort: String, arrivePort: String, airlineCom: String, infoNo: String, bookingRef: String) {
        
        self.type = type
        self.departDate = departDate
        self.arriveDate = arriveDate
        self.departPort = departPort
        self.arrivePort = arrivePort
        self.airlineCom = airlineCom
        self.infoNo = infoNo
        self.bookingRef = bookingRef
        
    }
    
}


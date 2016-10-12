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
    
    var postID: String?
    var type: String?
    var departDate: String?
    var arriveDate: String?
    var departFrom: String?
    var arriveAt: String?
    var airlineCom: String?
    var flightNo: String?
    var bookingRef: String?
    
    init(postID: String, type: String, departDate: String, arriveDate: String, departFrom: String, arriveAt: String, airlineCom: String, flightNo: String, bookingRef: String) {
        
        self.postID = postID
        self.type = type
        self.departDate = departDate
        self.arriveDate = arriveDate
        self.departFrom = departFrom
        
        self.arriveAt = arriveAt
        self.airlineCom = airlineCom
        self.flightNo = flightNo
        self.bookingRef = bookingRef
        
    }

}


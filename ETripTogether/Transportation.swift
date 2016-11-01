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
    
    let postID: String
    let transportationID: String
    let indexPathRow: Int
    let type: String
    let departDate: String
    let arriveDate: String
    let departFrom: String
    let arriveAt: String
    let airlineCom: String
    let flightNo: String
    let bookingRef: String
    
    init(postID: String, transportationID: String, indexPathRow: Int, type: String, departDate: String, arriveDate: String, departFrom: String, arriveAt: String, airlineCom: String, flightNo: String, bookingRef: String) {
        
        self.postID = postID
        self.transportationID = transportationID
        self.indexPathRow = indexPathRow
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


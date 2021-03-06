//
//  Post.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class Post {
    
    let postID: String
    let indexPathRow: Int
    let title: String
    let country: String
    
    //type needs to be re-defined
    var startDate: String
    var returnDate: String
    
    init(postID: String, indexPathRow: Int, title: String, country: String, startDate: String, returnDate: String) {
        
        self.postID = postID
        self.indexPathRow = indexPathRow
        self.title = title
        self.country = country
        self.startDate = startDate
        self.returnDate = returnDate
        
    }
}

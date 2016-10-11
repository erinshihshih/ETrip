//
//  Post.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class Post {
    
    var postID: String
    var title: String
    var country: String
    
    //type needs to be re-defined
    var startDate: String
    var returnDate: String
    
    init(postID: String, title: String, country: String, startDate: String, returnDate: String) {
        
        self.postID = postID
        self.title = title
        self.country = country
        self.startDate = startDate
        self.returnDate = returnDate
        
    }
}

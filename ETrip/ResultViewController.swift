//
//  ResultViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class ResultViewController: UITabBarController {
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Planner View
        let planViewController = self.viewControllers![0] as! PlannerViewController
        planViewController.post = post
        planViewController.transportation = transportation
        planViewController.attraction = attraction
        planViewController.tableView.reloadData()
        
        // Set up Map View
        let mapViewController = self.viewControllers![1] as! MapViewController
        mapViewController.post = post
//        mapViewController.transportation = transportation
//        mapViewController.attraction = attraction
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Planner View
        let destController = self.viewControllers![0] as! PlannerViewController
        destController.post = post
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewControlle
        // Pass the selected object to the new view controller.
    }
    */

}

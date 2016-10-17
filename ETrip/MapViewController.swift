//
//  MapViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/17.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = post?.title
        self.countryLabel.text = post?.country
        self.startDateLabel.text = post?.startDate
        self.returnDateLabel.text = post?.returnDate

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue" {
            let detailViewController = segue.destinationViewController as! EditViewController
            
            detailViewController.post = post
            
            print("Edit the trip.")
        }
    }

}

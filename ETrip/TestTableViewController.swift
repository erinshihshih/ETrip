//
//  TestTableViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/13.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        FirebaseManager.shared.delegate = self
        FirebaseManager.shared.fetchPosts()
    
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TestTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TestTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.countryLabel.text  = post.country
        cell.startDateLabel.text = post.startDate
        cell.returnDateLabel.text = post.returnDate
        
        return cell
    }

    
    
}

extension TestTableViewController: FirebaseManagerDelegate {
    
    func getPostManager(getPostManager: FirebaseManager, didGetData posts: [Post]) {
        
        self.posts = posts
        self.tableView.reloadData()
        
    }
    
    func getTransportationManager(getTransportationManager: FirebaseManager, didGetData transportation: Transportation) {
//        self.transportations = transportations
//        self.tableView.reloadData()
    }
    
    func getAttractionManager(getAttractionManager: FirebaseManager, didGetData attraction: Attraction) {
        
    }

}





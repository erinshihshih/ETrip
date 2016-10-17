//
//  PlannerViewController.swift
//  ETrip
//g
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var transportation: Transportation?
    var attraction: Attraction?
    
    enum Row {
        case transportation, attraction
    }
    
    var rows: [ Row ] = [  ]
    
    var post: Post?

    var allArray: [Any] = [ ]
    
    var transportations: [Transportation] = []
    var attractions: [Attraction] = []
    
    var isTransportationReceived = false
    var isAttractionReceived = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.titleLabel.text = post?.title
        self.countryLabel.text = post?.country
        self.startDateLabel.text = post?.startDate
        self.returnDateLabel.text = post?.returnDate
        
        // Firebase Manager Delegate
        FirebaseManager.shared.delegate = self
        FirebaseManager.shared.fetchTransportations()
        FirebaseManager.shared.fetchAttractions()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows.count
    }
    
    /////// Set up Table View ////////
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch rows[indexPath.row] {
            
        case .transportation:
            
            let cell = NSBundle.mainBundle().loadNibNamed("TransportationPlannerViewCell", owner: UITableViewCell.self, options: nil).first as! TransportationPlannerViewCell
            
            let transportation = allArray[indexPath.row] as! Transportation
            
          
            // Set up views if editing an existing data.
            cell.typeLabel.text = transportation.type
            cell.airlineComLabel.text = transportation.airlineCom
            cell.flightNoLabel.text = transportation.flightNo
            cell.bookingRefLabel.text = transportation.bookingRef
            cell.departFromLabel.text = transportation.departFrom
            cell.arriveAtLabel.text = transportation.arriveAt
            cell.departDateLabel.text = transportation.departDate
            cell.arriveDateLabel.text = transportation.arriveDate
 
            return cell
            
        case .attraction:
            
            let cell = NSBundle.mainBundle().loadNibNamed("AttractionPlannerViewCell", owner: UITableViewCell.self, options: nil).first as! AttractionPlannerViewCell
            
            let attraction = allArray[indexPath.row] as! Attraction
            
            // Set up views if editing an existing data.
            cell.nameLabel.text = attraction.name
            cell.stayHourLabel.text = attraction.stayHour
            cell.addressLabel.text = attraction.address
            cell.noteLabel.text = attraction.note

            return cell
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue" {
            let detailViewController = segue.destinationViewController as! EditViewController
            
            detailViewController.post = post
            var destAllarray = allArray
            destAllarray.insert(post!, atIndex: 0)
            detailViewController.allArray = destAllarray
            
            print("Edit the trip.")
        }
        
    }
    
    func sortMyArray(arr: [Any]) {
        
        if isTransportationReceived && isAttractionReceived {
            
        } else {
            return
        }
        
        var allIndex: [String:Int] = [ : ]
        rows = []
        
        for index in 0..<arr.count {
            
            if let card =  arr[index] as? Transportation {
                
                allIndex[String(index)] = card.indexPathRow
                
            }
            
            if let card =  arr[index] as? Attraction {
                
                allIndex[String(index)] = card.indexPathRow
                
            }
        }
        
        typealias DictSorter = ((String,Int),(String,Int)) -> Bool
        
        let indexSmallToLarge: DictSorter = { $0.1 < $1.1 }
        
        // selector
        let listSelector: (String,Int)->String = { $0.0 }
        
        // Usage
        let dict = allIndex
        
        let newArrayByIndexSmallToLarge = dict.sort(indexSmallToLarge).map(listSelector)
        
        var newArray: [Any] = []
        
        for index in 0..<newArrayByIndexSmallToLarge.count {
            
            let item = newArrayByIndexSmallToLarge[index]
            
            newArray.append(allArray[Int(item)!])
            
            if newArray[index] is Transportation{
                rows.append(.transportation)
            }
            
            if newArray[index] is Attraction{
                rows.append(.attraction)
            }
            
        }
        
        allArray = newArray
        self.tableView.reloadData()
        
    }
    
}


extension PlannerViewController: FirebaseManagerDelegate {
    
    func getPostManager(getPostManager: FirebaseManager, didGetData post: Post) {
        
    }
    
    func getTransportationManager(getTransportationManager: FirebaseManager, didGetData transportation: Transportation) {
        
        guard let postID = post?.postID else {
            print("getTransportationManager: Cannot find the postID")
            return
        }
        
        if transportation.postID == postID {
            
            self.transportations.append(transportation)
            allArray.append(transportation)
            print(allArray.count)
            isTransportationReceived = true
            self.rows.append(.transportation)
            
        }
        //排序
        sortMyArray(allArray)
        
    }
    
    
    func getAttractionManager(getAttractionManager: FirebaseManager, didGetData attraction: Attraction) {
        
        guard let postID = post?.postID else {
            print("getAttractionManager: Cannot find the postID")
            return
        }
        
        if attraction.postID == postID {
            
            self.attractions.append(attraction)
            allArray.append(attraction)
            print(allArray.count)
            isAttractionReceived = true
            self.rows.append(.attraction)
            
        }
        
        //排序
        sortMyArray(allArray)
        
    }
    
    
}


//
//  PlannerViewController.swift
//  ETrip
//g
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Row {
        case transportation, attraction, accommodation
    }
    
    var rows: [Row] = []
    
    var post: Post?

    var allArray: [Any] = [ ]
    
    var transportation: Transportation?
    var attraction: Attraction?
    var accommodation: Accommodation?
    
    var transportations: [Transportation] = []
    var attractions: [Attraction] = []
    var accommodations: [Accommodation] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
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
            
        case .accommodation:
            
            let cell = NSBundle.mainBundle().loadNibNamed("AccommodationPlannerViewCell", owner: UITableViewCell.self, options: nil).first as! AccommodationPlannerViewCell
            
            let accommodation = allArray[indexPath.row] as! Accommodation
            
            // Set up views if editing an existing data.
            cell.nameLabel.text = accommodation.name
            cell.addressLabel.text = accommodation.address
            cell.bookingRefLabel.text = accommodation.bookingRef
            cell.checkinDateLabel.text = accommodation.checkinDate
            cell.checkoutDateLabel.text = accommodation.checkoutDate
            cell.noteLabel.text = accommodation.note

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
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
    func sortMyArray(arr: [Any]) {
        
        
        var allIndex: [String:Int] = [ : ]
        rows = []
        
        for index in 0..<arr.count {
            
            if let card =  arr[index] as? Transportation {
                
                allIndex[String(index)] = card.indexPathRow
                
            }
            
            if let card =  arr[index] as? Attraction {
                
                allIndex[String(index)] = card.indexPathRow
                
            }
            
            if let card =  arr[index] as? Accommodation {
                
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
            
            if newArray[index] is Accommodation{
                rows.append(.accommodation)
            }
            
        }
        
        allArray = newArray
        self.tableView.reloadData()
        
    }
    
}


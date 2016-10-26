//
//  PlannerViewController.swift
//  ETrip
//g
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import PDFGenerator
import Firebase

//import Crashlytics

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Row {
        case transportation, attraction, accommodation
    }
  
    // MARK: - Property
    
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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func shareButton(sender: UIButton) {
        
//        let view : UIView = self.view //Any view can be here!
        
        let pdfFile = tableViewToPdfFile()
        
        let activityViewController = UIActivityViewController(activityItems: [pdfFile], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = sender
        self.self.presentViewController(activityViewController, animated: true, completion: nil)
        
        //        Crashlytics.sharedInstance().crash()
        
        FIRAnalytics.logEventWithName("SharePdf", parameters: ["name": (FIRAuth.auth()?.currentUser?.uid)!])

        
    }
    

    
    // UITableView -> PDF
    func tableViewToPdfFile() -> NSMutableData {
        
        let paperA4 = CGRect(x: -25, y: 25, width: 612, height: 892);
        let pageWithMargin = CGRect(x: 0, y: 0, width: paperA4.width-50, height: paperA4.height-50)
        
        let fittedSize: CGSize = self.tableView.sizeThatFits(CGSizeMake(pageWithMargin.width, self.tableView.contentSize.height))
        self.tableView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height)
        
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, paperA4, nil)
        
        for var pageOriginY:CGFloat = 0; pageOriginY < fittedSize.height; pageOriginY += paperA4.size.height {
            
            UIGraphicsBeginPDFPageWithInfo(paperA4, nil)
            
            CGContextSaveGState(UIGraphicsGetCurrentContext())
            
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY)
            
            self.tableView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        }
        
        UIGraphicsEndPDFContext()
        
        self.tableView.bounds = pageWithMargin // Reset the tableView
        
        return pdfData

//        // Store Pdf File to local finder
//        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
//        let pdfFileName = path.stringByAppendingPathComponent("testfilewnew.pdf")
//        
//        pdfData.writeToFile(pdfFileName, atomically: true)
//        
//        print(path)
        
    }

    
    // MARK: - Set up View

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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows.count
    }
    
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
            cell.addressLabel.text = attraction.address
            cell.phoneLabel.text = attraction.phone
            cell.websiteLabel.text = attraction.website

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
        
            return cell
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue" {
            let detailViewController = segue.destinationViewController as! AddViewController
            
//            detailViewController.rows = rows
            
            detailViewController.post = post
            
            detailViewController.allArrayTest = allArray
            
//
            
//            detailViewController.transportations = transportations
//            detailViewController.accommodations = accommodations
//            detailViewController.attractions = attractions
            
//            var destAllarray = allArray
//            destAllarray.insert(post!, atIndex: 0)
//            detailViewController.allArray = allArray
//            detailViewController.sortMyArray(allArray)
            
            
            
//            var post: Post?
//            var transportation: Transportation?
//            var attraction: Attraction?
//            var accommodation: Accommodation?
//            
//            var posts: [Post] = []
//            var attractions: [Attraction] = []
//            
//            var rows: [ Row ] = [ .title ]
//            var allArray: NSMutableArray = []
            
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
            
            if newArray[index] is Transportation {
                rows.append(.transportation)
            }
            
            if newArray[index] is Attraction {
                rows.append(.attraction)
            }
            
            if newArray[index] is Accommodation {
                rows.append(.accommodation)
            }
            
        }
        
        allArray = newArray
        self.tableView.reloadData()
        
    
        
    }
    
}


extension UIView {
    
    func getSnapshotImage(view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, 0)
        
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: false)
        
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return snapshotImage
        
        ////////////
//        var imageSize = CGSizeZero
//        
//        let orientation = UIApplication.sharedApplication().statusBarOrientation
//        if UIInterfaceOrientationIsPortrait(orientation) {
//            imageSize = UIScreen.mainScreen().bounds.size
//        } else {
//            imageSize = CGSize(width: UIScreen.mainScreen().bounds.size.height, height: UIScreen.mainScreen().bounds.size.width)
//        }
//        
//        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
//        let context = UIGraphicsGetCurrentContext()
//        for window in UIApplication.sharedApplication().windows {
//            CGContextSaveGState(context)
//            CGContextTranslateCTM(context, window.center.x, window.center.y)
//            CGContextConcatCTM(context, window.transform)
//            CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y)
//            if orientation == .LandscapeLeft {
//                CGContextRotateCTM(context, CGFloat(M_PI_2))
//                CGContextTranslateCTM(context, 0, -imageSize.width)
//            } else if orientation == .LandscapeRight {
//                CGContextRotateCTM(context, -CGFloat(M_PI_2))
//                CGContextTranslateCTM(context, -imageSize.height, 0)
//            } else if orientation == .PortraitUpsideDown {
//                CGContextRotateCTM(context, CGFloat(M_PI))
//                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height)
//            }
//            if window.respondsToSelector("drawViewHierarchyInRect:afterScreenUpdates:") {
//                window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
//            } else if let context = context {
//                window.layer.renderInContext(context)
//            }
//            CGContextRestoreGState(context)
//        }
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
    }
}


//
//  AddViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/14.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    var accommodation: Accommodation?
    
    var posts: [Post] = []
    var transportations: [Transportation] = []
    var attractions: [Attraction] = []
    var accommodations: [Accommodation] = []
    
    var isEditingTransportation = false
    var isEditingAttraction = false
    var isEditingAccommodation = false
    
    var countryArray = [String]()
    
    // title pickerView
    var pickerView = UIPickerView()
    var startDatePicker = UIDatePicker()
    var returnDatePicker = UIDatePicker()
    
    enum Row {
        case title, transportation, attraction, accommodation
    }
    
    var rows: [ Row ] = [ .title ]
    
    let databaseRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTransportationButton(sender: UIBarButtonItem) {
        
        isEditingTransportation = true
        rows.append(.transportation)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
        tableView.endUpdates()
        
    }
    
    @IBAction func addAttractionButton(sender: UIBarButtonItem) {
        
        isEditingAttraction = true
        rows.append(.attraction)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
        tableView.endUpdates()
        
    }
    
    @IBAction func addAccommodationButton(sender: UIBarButtonItem) {
        
        isEditingAccommodation = true
        rows.append(.accommodation)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
        tableView.endUpdates()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        // Country Picker
        for code in NSLocale.ISOCountryCodes() as [String] {
            
            let name = NSLocale.currentLocale().displayNameForKey(NSLocaleCountryCode, value: code) ?? "Country not found for code: \(code)"
            
            countryArray.append(name)
            countryArray.sortInPlace({ ( name1, name2) -> Bool in
                name1 < name2
            })
            
        }
        
        // Picker View UI
        setUpPickerViewUI()
        
        saveButton.enabled = false
        
        //        // Longpress to Reorder Cell
        //        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(AddViewController.longPressGestureRecognized(_:)))
        //        tableView.addGestureRecognizer(longpress)
        
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
        case .title:
            
            let cellIdentifier = "titleCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AddTableViewCell
            
            // Handle the text field’s user input via delegate callbacks.
            cell.startDateTextField.delegate = self
            cell.returnDateTextField.delegate = self
            
            // Set up views if editing an existing data.
            if let post = post {
                
                cell.titleTextField.text = post.title
                cell.countryTextField.text = post.country
                cell.startDateTextField.text = post.startDate
                cell.returnDateTextField.text = post.returnDate
            }
            
            cell.countryTextField.inputView = pickerView
            return cell
            
            
        case .transportation:
            
            let cell = NSBundle.mainBundle().loadNibNamed("TransportationTableViewCell", owner: UITableViewCell.self, options: nil).first as! TransportationTableViewCell
            
            // Handle the text field’s user input via delegate callbacks.
            cell.typeTextField.delegate = self
            cell.airlineComTextField.delegate = self
            cell.flightNoTextField.delegate = self
            cell.bookingRefTextField.delegate = self
            cell.departFromTextField.delegate = self
            cell.arriveAtTextField.delegate = self
            cell.departDateTextField.delegate = self
            cell.arriveDateTextField.delegate = self
            
            if !isEditingTransportation  {
                
                let theTransportation = transportations[indexPath.row - 1]
                
                // Set up views if editing an existing data.
                let transportation = theTransportation
                
                cell.typeTextField.text = transportation.type
                cell.airlineComTextField.text = transportation.airlineCom
                cell.flightNoTextField.text = transportation.flightNo
                cell.bookingRefTextField.text = transportation.bookingRef
                cell.departFromTextField.text = transportation.departFrom
                cell.arriveAtTextField.text = transportation.arriveAt
                cell.departDateTextField.text = transportation.departDate
                cell.arriveDateTextField.text = transportation.arriveDate
            }
            return cell
            
        case .attraction:
            
            let cell = NSBundle.mainBundle().loadNibNamed("AttractionTableViewCell", owner: UITableViewCell.self, options: nil).first as! AttractionTableViewCell
            
            // Handle the text field’s user input via delegate callbacks.
            cell.nameTextField.delegate = self
            cell.stayHourTextField.delegate = self
            cell.addressTextField.delegate = self
            cell.noteTextView.delegate = self
            
            if !isEditingAttraction  {
                
                let theAttraction = attractions[indexPath.row - transportations.count - 1]
                
                // Set up views if editing an existing data.
                let attraction = theAttraction
                
                cell.nameTextField.text = attraction.name
                cell.stayHourTextField.text = attraction.stayHour
                cell.addressTextField.text = attraction.address
                cell.noteTextView.text = attraction.note
                
            }
            
            return cell
            
        case .accommodation:
            
            let cell = NSBundle.mainBundle().loadNibNamed("AccommodationTableViewCell", owner: UITableViewCell.self, options: nil).first as! AccommodationTableViewCell
            
            // Handle the text field’s user input via delegate callbacks.
            cell.nameTextField.delegate = self
            cell.addressTextField.delegate = self
            cell.checkinDateTextField.delegate = self
            cell.checkoutDateTextField.delegate = self
            cell.noteTextView.delegate = self
            
            if !isEditingAccommodation  {
                
                let theAccommodation = accommodations[indexPath.row - transportations.count - attractions.count - 1]
                
                // Set up views if editing an existing data.
                let accommodation = theAccommodation
                
                cell.nameTextField.text = accommodation.name
                cell.addressTextField.text = accommodation.address
                cell.checkinDateTextField.text = accommodation.checkinDate
                cell.checkoutDateTextField.text = accommodation.checkoutDate
                cell.noteTextView.text = accommodation.note
                
                
            }
            
            return cell
            
            
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete{
            
            self.rows.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            
        }
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            
            let databaseRef = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            let postIDKey = FIRDatabase.database().reference().childByAutoId().key
            let timeStamp: NSNumber = Int(NSDate().timeIntervalSince1970)
            
            
            for index in 0..<rows.count {
                
                let row = rows[index]
                
                switch row {
                    
                case .title:
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    let indexPathRow = indexPath.row
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddTableViewCell
                    
                    // Trip Title Cell
                    let title = cell.titleTextField.text ?? ""
                    let country = cell.countryTextField.text ?? ""
                    
                    // needs to be re-designed > Date Picker
                    let startDate = cell.startDateTextField.text ?? ""
                    let returnDate = cell.returnDateTextField.text ?? ""
                    
                    // Store tripTitle in Firebase
                    let titleOnFire: [String: AnyObject] = ["uid": userID!,
                                                            "postID": postIDKey,
                                                            "indexPathRow": indexPathRow,
                                                            "timestamp": timeStamp,
                                                            "title": title,
                                                            "country": country,
                                                            "startDate": startDate,
                                                            "returnDate": returnDate ]
                    
                    databaseRef.child("posts").child(postIDKey).setValue(titleOnFire)
                    
                    // Set the post to be passed to HomeTableViewController after the unwind segue.
                    post = Post(postID: postIDKey, indexPathRow: indexPathRow, title: title, country: country, startDate: startDate, returnDate: returnDate)
                    
                case .transportation:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let indexPathRow = indexPath.row
                    let transportationIDKey = FIRDatabase.database().reference().childByAutoId().key
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! TransportationTableViewCell
                    
                    // Transportation Cell
                    let type = cell.typeTextField.text ?? ""
                    let airlineCom = cell.airlineComTextField.text ?? ""
                    let flightNo = cell.flightNoTextField.text ?? ""
                    let bookingRef = cell.bookingRefTextField.text ?? ""
                    let departFrom = cell.departFromTextField.text ?? ""
                    let arriveAt = cell.arriveAtTextField.text ?? ""
                    let departDate = cell.departDateTextField.text ?? ""
                    let arriveDate = cell.arriveDateTextField.text ?? ""
                    
                    
                    let transportationOnFire: [String: AnyObject] = [ "uid": userID!,
                                                                      "postID": postIDKey,
                                                                      "transportationID": transportationIDKey,
                                                                      "indexPathRow": indexPathRow,
                                                                      "timestamp": timeStamp,
                                                                      "type": type,
                                                                      "airlineCom": airlineCom,
                                                                      "flightNo": flightNo,
                                                                      "bookingRef": bookingRef,
                                                                      "departFrom": departFrom,
                                                                      "arriveAt": arriveAt,
                                                                      "departDate": departDate,
                                                                      "arriveDate": arriveDate ]
                    
                    databaseRef.child("transportations").child(transportationIDKey).setValue(transportationOnFire)
                    
                case .attraction:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let indexPathRow = indexPath.row
                    let attractionIDKey = FIRDatabase.database().reference().childByAutoId().key
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! AttractionTableViewCell
                    
                    // Attraction Cell
                    let name = cell.nameTextField.text ?? ""
                    let stayHour = cell.stayHourTextField.text ?? ""
                    let address = cell.addressTextField.text ?? ""
                    let note = cell.noteTextView.text ?? ""
                    
                    let attractionOnFire: [String: AnyObject] = [ "uid": userID!,
                                                                  "postID": postIDKey,
                                                                  "attractionID": attractionIDKey,
                                                                  "indexPathRow": indexPathRow,
                                                                  "timestamp": timeStamp,
                                                                  "name": name,
                                                                  "stayHour": stayHour,
                                                                  "address": address,
                                                                  "note": note ]
                    
                    databaseRef.child("attractions").child(attractionIDKey).setValue(attractionOnFire)
                    
                case .accommodation:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let indexPathRow = indexPath.row
                    let accommodationIDKey = FIRDatabase.database().reference().childByAutoId().key
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! AccommodationTableViewCell
                    
                    // Accommodation Cell
                    let name = cell.nameTextField.text ?? ""
                    let address = cell.addressTextField.text ?? ""
                    let checkinDate = cell.checkinDateTextField.text ?? ""
                    let checkoutDate = cell.checkoutDateTextField.text ?? ""
                    let bookingRef = cell.bookingRefTextField.text ?? ""
                    let note = cell.noteTextView.text ?? ""
                    
                    let accommodationOnFire: [String: AnyObject] = [ "uid": userID!,
                                                                     "postID": postIDKey,
                                                                     "accommodationID": accommodationIDKey,
                                                                     "indexPathRow": indexPathRow,
                                                                     "timestamp": timeStamp,
                                                                     "name": name,
                                                                     "address": address,
                                                                     "checkinDate": checkinDate,
                                                                     "checkoutDate": checkoutDate,
                                                                     "bookingRef": bookingRef,
                                                                     "note": note ]
                    
                    databaseRef.child("accommodations").child(accommodationIDKey).setValue(accommodationOnFire)
                    
                    
                    
                }
            }
        }
    }
    
    // Country Picker Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddTableViewCell
        cell.countryTextField.text = countryArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        return title
        
    }
    
    // Date TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if let cell = textField.superview?.superview as? AddTableViewCell {
            
            cell.startDateTextField.inputView = startDatePicker
            cell.returnDateTextField.inputView = returnDatePicker
            //        startDatePicker.reloadInputViews()
            startDatePicker.addTarget(self, action: #selector(AddViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
            returnDatePicker.addTarget(self, action: #selector(AddViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
        }
        
        // 等新增完其他cell再做判斷
        //        if  let cell = textField.superview?.superview as? TransportationTableViewCell {
        //            print("it's transportation Cell!")
        //        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if let cell = textField.superview?.superview as? AddTableViewCell {
            
            if cell.startDateTextField.text != nil {
                
                saveButton.enabled = true
                
            } else {
                
                saveButton.enabled = false
            }
        }
    }
    
    
    func updateDateField(sender: UIDatePicker) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy HH:mm"
        
        if sender == startDatePicker {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddTableViewCell
            cell.startDateTextField.text = formatter.stringFromDate(sender.date)
            
        } else if sender == returnDatePicker {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddTableViewCell
            cell.returnDateTextField.text = formatter.stringFromDate(sender.date)
            
        }
    }
    
    // Set Up PickerView UI
    func setUpPickerViewUI() {
        
        // Country Picker
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
        
        // Date Picker
        startDatePicker.minuteInterval = 30
        startDatePicker.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
        startDatePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        
        returnDatePicker.minuteInterval = 30
        returnDatePicker.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
        returnDatePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    
    
    //     Override to support rearranging the table view.
    //    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    //        let itemToMove = rows[fromIndexPath.row]
    //        rows.removeAtIndex(fromIndexPath.row)
    //        rows.insert(itemToMove, atIndex: toIndexPath.row)
    //    }
    //
    
    
    // Override to support conditional rearranging of the table view.
    //     func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //
    //        return true
    //     }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//    // Longpress to Reorder Cell
//    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
//        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
//        let state = longPress.state
//        let locationInView = longPress.locationInView(tableView)
//        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
//
//        struct My {
//            static var cellSnapshot : UIView? = nil
//            static var cellIsAnimating : Bool = false
//            static var cellNeedToShow : Bool = false
//        }
//
//        struct Path {
//            static var initialIndexPath : NSIndexPath? = nil
//        }
//
//        switch state {
//        case UIGestureRecognizerState.Began:
//            if indexPath != nil {
//                Path.initialIndexPath = indexPath
//                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
//                My.cellSnapshot  = snapshotOfCell(cell)
//
//                var center = cell.center
//                My.cellSnapshot!.center = center
//                My.cellSnapshot!.alpha = 0.0
//                tableView.addSubview(My.cellSnapshot!)
//
//                UIView.animateWithDuration(0.25, animations: { () -> Void in
//                    center.y = locationInView.y
//                    My.cellIsAnimating = true
//                    My.cellSnapshot!.center = center
//                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
//                    My.cellSnapshot!.alpha = 0.98
//                    cell.alpha = 0.0
//                    }, completion: { (finished) -> Void in
//                        if finished {
//                            My.cellIsAnimating = false
//                            if My.cellNeedToShow {
//                                My.cellNeedToShow = false
//                                UIView.animateWithDuration(0.25, animations: { () -> Void in
//                                    cell.alpha = 1
//                                })
//                            } else {
//                                cell.hidden = true
//                            }
//                        }
//                })
//            }
//
//        case UIGestureRecognizerState.Changed:
//            if My.cellSnapshot != nil {
//                var center = My.cellSnapshot!.center
//                center.y = locationInView.y
//                My.cellSnapshot!.center = center
//
//                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
//                    rows.insert(rows.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
//                    tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
//                    Path.initialIndexPath = indexPath
//                    print(indexPath?.row)
//                }
//            }
//        default:
//            if Path.initialIndexPath != nil {
//                let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
//                if My.cellIsAnimating {
//                    My.cellNeedToShow = true
//                } else {
//                    cell.hidden = false
//                    cell.alpha = 0.0
//                }
//
//                UIView.animateWithDuration(0.25, animations: { () -> Void in
//                    My.cellSnapshot!.center = cell.center
//                    My.cellSnapshot!.transform = CGAffineTransformIdentity
//                    My.cellSnapshot!.alpha = 0.0
//                    cell.alpha = 1.0
//
//                    }, completion: { (finished) -> Void in
//                        if finished {
//                            Path.initialIndexPath = nil
//                            My.cellSnapshot!.removeFromSuperview()
//                            My.cellSnapshot = nil
//                        }
//                })
//            }
//        }
//    }
//
//    func snapshotOfCell(inputView: UIView) -> UIView {
//        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
//        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
//        UIGraphicsEndImageContext()
//
//        let cellSnapshot : UIView = UIImageView(image: image)
//        cellSnapshot.layer.masksToBounds = false
//        cellSnapshot.layer.cornerRadius = 0.0
//        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
//        cellSnapshot.layer.shadowRadius = 5.0
//        cellSnapshot.layer.shadowOpacity = 0.4
//        return cellSnapshot
//    }


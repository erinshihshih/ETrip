//
//  EditTableViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/30.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMaps
import GooglePlacePicker

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    enum Row {
        case title, transportation, attraction, accommodation
    }
    
    // MARK: Property
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    var accommodation: Accommodation?
    
    var transportations: [Transportation] = []
    var attractions: [Attraction] = []
    var accommodations: [Accommodation] = []
    
    var rows: [ Row ] = [ .title ]
    var allArray: [Any] = [ ]
    
    var isEditingTransportation = false
    var isEditingAttraction = false
    var isEditingAccommodation = false
    
    var isPostReceived = true
    var isTransportationReceived = false
    var isAttractionReceived = false
    var isAccommodationReceived = false
    
    // Set up Google Places
    var attractionCell: AttractionTableViewCell?
    var accommodationCell: AccommodationTableViewCell?
    
    var countryArray = [String]()
    
    // title pickerView
    var pickerView = UIPickerView()
    var startDatePicker = UIDatePicker()
    var returnDatePicker = UIDatePicker()
    
    let databaseRef = FIRDatabase.database().reference()
    
    // MARK: IBOutlet
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTransportationButton(sender: UIBarButtonItem) {
        
        isEditingTransportation = true
        rows.append(.transportation)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
        tableView.endUpdates()
        //
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
    
    func onLaunchClicked(sender: UIButton) {
        
        if let sender = sender.superview?.superview as? AttractionTableViewCell{
            
            attractionCell = sender
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            self.presentViewController(acController, animated: true, completion: nil)
        }
        
        if let sender = sender.superview?.superview as? AccommodationTableViewCell{
            
            accommodationCell = sender
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            self.presentViewController(acController, animated: true, completion: nil)
        }
        
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
        
        // Longpress to Reorder Cell
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(EditViewController.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
        
        //        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        sortMyArray(allArray)
        
        
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
            
            
            //            let cellIdentifier = "titleCell"
            //            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EditTableViewCell
            if allArray.count - 1 >= indexPath.row {
                
                let cell = allArray[indexPath.row] as! EditTableViewCell
                
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
                
                allArray[indexPath.row] = cell
                
                return cell
                
            } else {
                
                let cellIdentifier = "titleCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EditTableViewCell
                
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
                
                allArray.append(cell)
                
                return cell
            }
            
            
            
        case .transportation:
            
            //            let cell = NSBundle.mainBundle().loadNibNamed("TransportationTableViewCell", owner: UITableViewCell.self, options: nil).first as! TransportationTableViewCell
            
            if allArray.count - 1 >= indexPath.row {
                
                let cell = allArray[indexPath.row] as! TransportationTableViewCell
                
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
                    
                    transportation = allArray[indexPath.row] as? Transportation
                    
                    // Set up views if editing an existing data.
                    cell.typeTextField.text = transportation!.type
                    cell.airlineComTextField.text = transportation!.airlineCom
                    cell.flightNoTextField.text = transportation!.flightNo
                    cell.bookingRefTextField.text = transportation!.bookingRef
                    cell.departFromTextField.text = transportation!.departFrom
                    cell.arriveAtTextField.text = transportation!.arriveAt
                    cell.departDateTextField.text = transportation!.departDate
                    cell.arriveDateTextField.text = transportation!.arriveDate
                }
                allArray[indexPath.row] = cell
                return cell
                
            } else {
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
                
                if !isEditingTransportation {
                    
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
                
                allArray.append(cell)
                return cell
            }
            
            
        case .attraction:
            //
            //            let cell = NSBundle.mainBundle().loadNibNamed("AttractionTableViewCell", owner: UITableViewCell.self, options: nil).first as! AttractionTableViewCell
            if allArray.count - 1 >= indexPath.row {
                
                let cell = allArray[indexPath.row] as! AttractionTableViewCell
                
                
                cell.searchButton.addTarget(self, action: #selector(EditViewController.onLaunchClicked(_:)), forControlEvents: .TouchUpInside)
                
                if !isEditingAttraction  {
                    
                    attraction = allArray[indexPath.row] as? Attraction
                    
                    cell.nameLabel.text = attraction!.name
                    cell.phoneLabel.text = attraction!.phone
                    cell.addressLabel.text = attraction!.address
                    cell.websiteLabel.text = attraction!.website
                }
                
                allArray[indexPath.row] = cell
                return cell
                
            } else {
                let cell = NSBundle.mainBundle().loadNibNamed("AttractionTableViewCell", owner: UITableViewCell.self, options: nil).first as! AttractionTableViewCell
                
                // Handle the text field’s user input via delegate callbacks.
                
                cell.searchButton.addTarget(self, action: #selector(AddViewController.onLaunchClicked(_:)), forControlEvents: .TouchUpInside)
                
                if !isEditingAttraction {
                    
                    let theAttraction = attractions[indexPath.row - transportations.count - 1]
                    
                    // Set up views if editing an existing data.
                    let attraction = theAttraction
                    
                    cell.nameLabel.text = attraction.name
                    cell.phoneLabel.text = attraction.phone
                    cell.addressLabel.text = attraction.address
                    cell.websiteLabel.text = attraction.website
                    
                }
                
                allArray.append(cell)
                return cell
            }
            
            
            
        case .accommodation:
            
            //            let cell = NSBundle.mainBundle().loadNibNamed("AccommodationTableViewCell", owner: UITableViewCell.self, options: nil).first as! AccommodationTableViewCell
            
            if allArray.count - 1 >= indexPath.row {
                
                let cell = NSBundle.mainBundle().loadNibNamed("AccommodationTableViewCell", owner: UITableViewCell.self, options: nil).first as! AccommodationTableViewCell
                
                
                // Handle the text field’s user input via delegate callbacks.
                cell.checkinDateTextField.delegate = self
                cell.checkoutDateTextField.delegate = self
                cell.bookingRefTextField.delegate = self
                
                
                cell.searchButton.addTarget(self, action: #selector(EditViewController.onLaunchClicked(_:)), forControlEvents: .TouchUpInside)
                
                if !isEditingAccommodation  {
                    
                    accommodation = allArray[indexPath.row] as? Accommodation
                    
                    // Set up views if editing an existing data.
                    cell.nameLabel.text = accommodation!.name
                    cell.addressLabel.text = accommodation!.address
                    cell.checkinDateTextField.text = accommodation!.checkinDate
                    cell.checkoutDateTextField.text = accommodation!.checkoutDate
                    cell.bookingRefTextField.text = accommodation!.bookingRef
                    
                    
                }
                
                allArray[indexPath.row] = cell
                return cell
                
            } else {
                
                let cell = NSBundle.mainBundle().loadNibNamed("AccommodationTableViewCell", owner: UITableViewCell.self, options: nil).first as! AccommodationTableViewCell
                cell.checkinDateTextField.delegate = self
                cell.checkoutDateTextField.delegate = self
                
                cell.searchButton.addTarget(self, action: #selector(AddViewController.onLaunchClicked(_:)), forControlEvents: .TouchUpInside)
                
                if !isEditingAccommodation {
                    
                    let theAccommodation = accommodations[indexPath.row - transportations.count - attractions.count - 1]
                    
                    // Set up views if editing an existing data.
                    let accommodation = theAccommodation
                    
                    cell.nameLabel.text = accommodation.name
                    cell.addressLabel.text = accommodation.address
                    cell.checkinDateTextField.text = accommodation.checkinDate
                    cell.checkoutDateTextField.text = accommodation.checkoutDate
                    
                }
                
                allArray.append(cell)
                return cell
            }
            
            
            
        }
        
    }
    
    
    //        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //            return UITableViewAutomaticDimension
    //        }
    //
    //        func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //            return UITableViewAutomaticDimension
    //        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if updateButton === sender {
            
            let databaseRef = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            guard let postID = post?.postID else {
                return
            }
            
            let timeStamp: NSNumber = Int(NSDate().timeIntervalSince1970)
            
            FIRAnalytics.logEventWithName("press_updateButton", parameters: ["name": userID!])
            
            for index in 0..<rows.count {
                
                let row = rows[index]
                
                switch row {
                    
                case .title:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    //                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditTableViewCell
                    let indexPathRow = indexPath.row
                    
                    if let cell = allArray[indexPathRow] as? EditTableViewCell {
                        
                        // Trip Title Cell
                        let title = cell.titleTextField.text ?? ""
                        let country = cell.countryTextField.text ?? ""
                        
                        // needs to be re-designed > Date Picker
                        let startDate = cell.startDateTextField.text ?? ""
                        let returnDate = cell.returnDateTextField.text ?? ""
                        
                        // Store tripTitle in Firebase
                        let titleOnFire: [String: AnyObject] = ["uid": userID!,
                                                                "postID": postID,
                                                                "indexPathRow": indexPathRow,
                                                                "timestamp": timeStamp,
                                                                "title": title,
                                                                "country": country,
                                                                "startDate": startDate,
                                                                "returnDate": returnDate ]
                        
                        let updatedTitleOnFire = ["/posts/\(postID)": titleOnFire]
                        databaseRef.updateChildValues(updatedTitleOnFire)
                        
                        
                    } else { return }
                    
                case .transportation:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    //                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! TransportationTableViewCell
                    let indexPathRow = indexPath.row
                    
                    guard let selectedTransportation = allArray[indexPathRow] as? Transportation else {
                        fatalError()
                    }
                    
                    let cell = allArray[indexPathRow] as! TransportationTableViewCell
                    
                    let transportationID = selectedTransportation.transportationID
                    
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
                                                                      "postID": postID,
                                                                      "transportationID": transportationID,
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
                    
                    databaseRef.child("transportations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                        snapshot in
                        
                        let transportationsPostID = snapshot.value!["postID"] as! String
                        //                       let transportationsindexPathRow = snapshot.value!["indexPathRow"] as! Int
                        //                        let transportationID = self.transportation?.transportationID
                        let transportationKeyID = snapshot.key
                        
                        if transportationsPostID == postID && transportationKeyID == transportationID {
                            
                            let updatedTransportationOnFire = ["/transportations/\(transportationKeyID)": transportationOnFire]
                            
                            databaseRef.updateChildValues(updatedTransportationOnFire)
                        }
                    })
                    
                    
                case .attraction:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    //                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! AttractionTableViewCell
                    let indexPathRow = indexPath.row
                    
                    guard let selectedAttraction = allArray[indexPathRow] as? Attraction else {
                        fatalError()
                    }
                    
                    let attractionID = selectedAttraction.attractionID
                    
                    if let cell = allArray[indexPathRow] as? AttractionTableViewCell {
                        
                        // Attraction Cell
                        let name = cell.nameLabel.text ?? ""
                        let address = cell.addressLabel.text ?? ""
                        let phone = cell.phoneLabel.text ?? ""
                        let website = cell.websiteLabel.text ?? ""
                        
                        let attractionOnFire: [String: AnyObject] = [ "uid": userID!,
                                                                      "postID": postID,
                                                                      "attractionID": attractionID,
                                                                      "indexPathRow": indexPathRow,
                                                                      "timestamp": timeStamp,
                                                                      "name": name,
                                                                      "address": address,
                                                                      "phone": phone,
                                                                      "website": website ]
                        
                        databaseRef.child("attractions").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                            snapshot in
                            
                            let attractionsPostID = snapshot.value!["postID"] as! String
                            let attractionKeyID = snapshot.key
                            
                            if attractionsPostID == postID && attractionID == attractionKeyID {
                                
                                let updatedAttractionOnFire = ["/attractions/\(attractionKeyID)": attractionOnFire]
                                
                                databaseRef.updateChildValues(updatedAttractionOnFire)
                            }
                        })
                    } else { return }
                    
                case .accommodation:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    //                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! AccommodationTableViewCell
                    let indexPathRow = indexPath.row
                    
                    guard let selectedAccommodation = allArray[indexPathRow] as? Accommodation else {
                        fatalError()
                    }
                    let cell = allArray[indexPathRow] as! AccommodationTableViewCell
                    
                    let accommodationID = selectedAccommodation.accommodationID
                    
                    // Accommodation Cell
                    let name = cell.nameLabel.text ?? ""
                    //                    let phone = cell.phoneLabel.text ?? ""
                    let address = cell.addressLabel.text ?? ""
                    let checkinDate = cell.checkinDateTextField.text ?? ""
                    let checkoutDate = cell.checkoutDateTextField.text ?? ""
                    let bookingRef = cell.bookingRefTextField.text ?? ""
                    
                    
                    let accommodationOnFire: [String: AnyObject] = [ "uid": userID!,
                                                                     "postID": postID,
                                                                     "accommodationID": accommodationID,
                                                                     "indexPathRow": indexPathRow,
                                                                     "timestamp": timeStamp,
                                                                     "name": name,
                                                                     //                                                                     "phone": phone,
                        "address": address,
                        "checkinDate": checkinDate,
                        "checkoutDate": checkoutDate,
                        "bookingRef": bookingRef ]
                    
                    databaseRef.child("accommodations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                        snapshot in
                        
                        let accommodationsPostID = snapshot.value!["postID"] as! String
                        let accommodationKeyID = snapshot.key
                        
                        if accommodationsPostID == postID && accommodationID == accommodationKeyID {
                            
                            let updatedAccommodationOnFire = ["/accommodations/\(accommodationKeyID)": accommodationOnFire]
                            
                            databaseRef.updateChildValues(updatedAccommodationOnFire)
                        }
                    })
                    
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditTableViewCell
        cell.countryTextField.text = countryArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        return title
        
    }
    
    // Date TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if let cell = textField.superview?.superview as? EditTableViewCell {
            cell.startDateTextField.inputView = startDatePicker
            cell.returnDateTextField.inputView = returnDatePicker
            //        startDatePicker.reloadInputViews()
            startDatePicker.addTarget(self, action: #selector(EditViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
            returnDatePicker.addTarget(self, action: #selector(EditViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
        }
        
        // 等新增完其他cell再做判斷
        //        if  let cell = textField.superview?.superview as? TransportationTableViewCell {
        //            print("it's transportation Cell!")
        //        }
        
        
        
    }
    
    func updateDateField(sender: UIDatePicker) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy HH:mm"
        
        if sender == startDatePicker {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditTableViewCell
            cell.startDateTextField.text = formatter.stringFromDate(sender.date)
            
        } else if sender == returnDatePicker {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditTableViewCell
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
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.rows.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.tableView.reloadData()
            
        }
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func sortMyArray(arr: [Any]) {
        
        var allIndex:[Int] = []
        rows = []
        
        for index in 0..<arr.count {
            if let card =  arr[index] as? Post {
                allIndex.append(0)
            }
            
            if let card =  arr[index] as? Transportation {
                allIndex.append(card.indexPathRow)
            }
            
            if let card =  arr[index] as? Attraction {s
                allIndex.append(card.indexPathRow)
            }
            
            if let card =  arr[index] as? Accommodation {
                allIndex.append(card.indexPathRow)
            }
        }
        
        var newArray: [Any] = []
        
        for index in 0..<allIndex.count{
            
            let numberInx = allIndex[index]
            
            newArray.append(allArray[numberInx])
            
            if newArray[index] is Post{
                rows.append(.title)
            }
            
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
    // Longpress to Reorder Cell
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell)
                
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            My.cellIsAnimating = false
                            if My.cellNeedToShow {
                                My.cellNeedToShow = false
                                UIView.animateWithDuration(0.25, animations: { () -> Void in
                                    cell.alpha = 1
                                })
                            } else {
                                cell.hidden = true
                            }
                        }
                })
            }
            
        case UIGestureRecognizerState.Changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    rows.insert(rows.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                    
                    //                    // Edited
                    //                    var swiftArray = allArray as NSArray as [AnyObject]
                    //                    swiftArray.insert(swiftArray.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                    //                    allArray.removeAllObjects()
                    //                    allArray.addObjectsFromArray(swiftArray)
                    
                    tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                    Path.initialIndexPath = indexPath
                    print(indexPath?.row)
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = cell.center
                    My.cellSnapshot!.transform = CGAffineTransformIdentity
                    My.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            Path.initialIndexPath = nil
                            My.cellSnapshot!.removeFromSuperview()
                            My.cellSnapshot = nil
                        }
                })
            }
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    
    
}

// MARK: GMSAutocompleteViewControllerDelegate

extension EditViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        
        print("Place: \(place)")
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("Place coordinate: \(place.coordinate)")
        
        if attractionCell != nil {
            
            attractionCell!.nameLabel.text = place.name
            attractionCell!.addressLabel.text = place.formattedAddress
            attractionCell!.phoneLabel.text = place.phoneNumber
            
            if place.website == nil {
                
                attractionCell!.websiteLabel.text = "No website info found!"
                
            } else {
                
                attractionCell!.websiteLabel.text = "\(place.website!)"
                
            }
            
        } else if accommodationCell != nil{
            
            accommodationCell!.nameLabel.text = place.name
            accommodationCell!.addressLabel.text = place.formattedAddress
            
        }
        
        
        attractionCell = nil
        accommodationCell = nil
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: \(error.description)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}



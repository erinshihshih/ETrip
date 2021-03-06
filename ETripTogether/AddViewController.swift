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
import GoogleMaps
import GooglePlacePicker
import LiquidFloatingActionButton

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {
    
    enum Row {
        case title, transportation, attraction, accommodation
    }
    
    // MARK: Property
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    var accommodation: Accommodation?
    
    var posts: [Post] = []
    var transportations: [Transportation] = []
    var attractions: [Attraction] = []
    var accommodations: [Accommodation] = []
    
    var rows: [ Row ] = [ .title ]
    var allArray: NSMutableArray = []
    var allArrayTest: [Any] = []
    
    var isEditingTransportation = false
    var isEditingAttraction = false
    var isEditingAccommodation = false
    
    // Set up Google Places
    var attractionCell: AttractionTableViewCell?
    var accommodationCell: AccommodationTableViewCell?
    
    //    var transportationCell: TransportationTableViewCell?
    
    
    // PickerView
    var pickerView = UIPickerView()
    //    var transportationPickerView = UIPickerView()
    var startDatePicker = UIDatePicker()
    var returnDatePicker = UIDatePicker()
    var transportationTypePickerView = UIPickerView()
    var transportationDepartDatePickerView = UIDatePicker()
    
    enum PickerType: Int {
        case country = 0
        case transportationType = 1
        
    }
    
    var currentEditingTypeTextField: UITextField?
    
    var countryArray = [String]()
    
    let transportationTypeArray = [ "Airplane", "Bus", "Train" ]
    
    let databaseRef = FIRDatabase.database().reference()
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    // MARK: IBOutlet
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isFirstAdd = true
    
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Picker View UI
        setUpPickerViewUI()
        
        // Country Picker
        for code in NSLocale.ISOCountryCodes() as [String] {
            
            let name = NSLocale.currentLocale().displayNameForKey(NSLocaleCountryCode, value: code) ?? "Country not found for code: \(code)"
            
            countryArray.append(name)
            countryArray.sortInPlace({ ( name1, name2) -> Bool in
                name1 < name2
            })
            
        }

        
        //choose which pickerview is used
        pickerView.tag = 0
        transportationTypePickerView.tag = 1
        
        saveButton.enabled = false
        
        // Longpress to Reorder Cell
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(AddViewController.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
        
        // LiquidButton
        createLiquidFloatingActionButton()
        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if allArrayTest.count < 1 {
            return
        }
        
        if !isFirstAdd {
            
            return
        }
        
        for type in allArrayTest {
            
            if type is Transportation {
                
                isEditingTransportation = true
                rows.append(.transportation)
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
                tableView.endUpdates()
                
            }
            
            if type is Attraction {
                
                isEditingAttraction = true
                rows.append(.attraction)
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
                tableView.endUpdates()
                
            }
            
            if type is Accommodation {
                
                isEditingAccommodation = true
                rows.append(.accommodation)
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
                tableView.endUpdates()
                
            }
        }
        
        isFirstAdd = false
        
        
        for (index, type) in allArray.enumerate() {
            
            if index > 0 {
                
                if let item = allArrayTest[index - 1] as? Transportation {
                    
                    let cell = allArray[index] as! TransportationTableViewCell
                    cell.typeTextField.text = item.type
                    cell.airlineComTextField.text = item.airlineCom
                    cell.flightNoTextField.text = item.flightNo
                    cell.bookingRefTextField.text = item.bookingRef
                    cell.departFromTextField.text = item.departFrom
                    cell.arriveAtTextField.text = item.arriveAt
                    cell.departDateTextField.text = item.departDate
                    cell.arriveDateTextField.text = item.arriveDate
                    
                }
                
                if let item = allArrayTest[index - 1] as? Attraction {
                    
                    let cell = allArray[index] as! AttractionTableViewCell
                    cell.nameLabel.text = item.name
                    cell.phoneLabel.text = item.phone
                    cell.addressLabel.text = item.address
                    cell.websiteLabel.text = item.website
                }
                
                if let item = allArrayTest[index - 1] as? Accommodation {
                    
                    let cell = allArray[index] as! AccommodationTableViewCell
                    
                    cell.nameLabel.text = item.name
                    cell.addressLabel.text = item.address
                    cell.checkinDateTextField.text = item.checkinDate
                    cell.checkoutDateTextField.text = item.checkoutDate
                    
                }
            }
        }
    }
    
    
    
    // MARK: Function
    
    // TASK: Setting Google Places
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
    
    //TASK: Create LiquidFloatingActionButton
    func createLiquidFloatingActionButton() {
        
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = CustomDrawingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
            return cell
        }
        let customCellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = CustomCell(icon: UIImage(named: iconName)!, name: iconName)
            return cell
        }
        cells.append(cellFactory("transportation"))
        cells.append(customCellFactory("attraction"))
        cells.append(cellFactory("accommodation"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 45 - 10, y: view.frame.height - 45 - 80, width: 45, height: 45)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        bottomRightButton.color = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 1)
        bottomRightButton.image = UIImage(named: "add")
        self.view.addSubview(bottomRightButton)
        
    }
    
    
    //TASK: Setting LiquidFloatingActionButton function
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        
        switch index {
            
        case 0:
            
            isEditingTransportation = true
            rows.append(.transportation)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
            tableView.endUpdates()
            
            moveTableViewToLastCell()
            
            liquidFloatingActionButton.close()
            
        case 1:
            
            isEditingAttraction = true
            rows.append(.attraction)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
            tableView.endUpdates()
            
            moveTableViewToLastCell()
            
            liquidFloatingActionButton.close()
            
        case 2:
            
            isEditingAccommodation = true
            rows.append(.accommodation)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows.count - 1, inSection: 0)], withRowAnimation: .Bottom)
            tableView.endUpdates()
            
            moveTableViewToLastCell()
            
            liquidFloatingActionButton.close()
            
        default: break
        }
        
    }
    
    func moveTableViewToLastCell() {
        
        // First figure out how many sections there are
        let lastSectionIndex = self.tableView.numberOfSections - 1
        
        // Then grab the number of rows in the last section
        let lastRowIndex = self.tableView.numberOfRowsInSection(lastSectionIndex) - 1
        
        // Now just construct the index path
        let pathToLastRow = NSIndexPath(forRow: lastRowIndex, inSection: lastSectionIndex)
        
        // Make the last row visible
        self.tableView.scrollToRowAtIndexPath(pathToLastRow, atScrollPosition: UITableViewScrollPosition.None, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch rows[indexPath.row] {
            
        case .title:
            
            if allArray.count - 1 >= indexPath.row {
                
                let cell = allArray[indexPath.row] as! AddTableViewCell
                
                // Handle the text field’s user input via delegate callbacks.
                cell.titleTextField.delegate = self
                cell.countryTextField.delegate = self
                cell.startDateTextField.delegate = self
                cell.returnDateTextField.delegate = self
                cell.countryTextField.inputView = pickerView
                
                allArray[indexPath.row] = cell
                
                return cell
                
            } else {
                
                let cellIdentifier = "titleCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AddTableViewCell
                
                // Handle the text field’s user input via delegate callbacks.
                cell.titleTextField.delegate = self
                cell.countryTextField.delegate = self
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
                
                allArray.addObject(cell)
                
                return cell
            }
            
        case .transportation:
            
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
                
                allArray.addObject(cell)
                return cell
            }
            
        case .attraction:
            
            if allArray.count - 1 >= indexPath.row {
                
                let cell = allArray[indexPath.row] as! AttractionTableViewCell
                
                // Handle the text field’s user input via delegate callbacks.
                
                cell.searchButton.addTarget(self, action: #selector(AddViewController.onLaunchClicked(_:)), forControlEvents: .TouchUpInside)
                
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
                
                allArray.addObject(cell)
                return cell
            }
            
        case .accommodation:
            
            if allArray.count - 1 >= indexPath.row {
                
                let cell = allArray[indexPath.row] as! AccommodationTableViewCell
                
                cell.checkinDateTextField.delegate = self
                cell.checkoutDateTextField.delegate = self
                
                cell.searchButton.addTarget(self, action: #selector(AddViewController.onLaunchClicked(_:)), forControlEvents: .TouchUpInside)
                
                
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
                
                allArray.addObject(cell)
                return cell
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.rows.removeAtIndex(indexPath.row)
            self.allArray.removeObjectAtIndex(indexPath.row)
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
    
    // MARK: PrepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            
            let databaseRef = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            let postIDKey = FIRDatabase.database().reference().childByAutoId().key
            let timeStamp: NSNumber = Int(NSDate().timeIntervalSince1970)
            
            FIRAnalytics.logEventWithName("press_saveButton", parameters: ["name": userID!])
            
            for index in 0..<rows.count {
                
                let row = rows[index]
                
                switch row {
                    
                case .title:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let indexPathRow = indexPath.row
                    
                    if let cell = allArray[indexPathRow] as? AddTableViewCell {
                        
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
                        
                        //////////////
                        let n: Int! = self.navigationController?.viewControllers.count
                        if (self.navigationController?.viewControllers[n-2] as? HomeTableViewController) != nil{
                            
                            databaseRef.child("posts").child(postIDKey).setValue(titleOnFire)
                            
                        } else {
                            
                            guard let postID = post?.postID else {
                                return
                            }
                            
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
                            
                        }
                        
                        // Set the post to be passed to HomeTableViewController after the unwind segue.
                        post = Post(postID: postIDKey, indexPathRow: indexPathRow, title: title, country: country, startDate: startDate, returnDate: returnDate)
                        
                    } else {
                        print("prepareForSegue: title cast wrong")
                        return
                    }
                    
                case .transportation:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let indexPathRow = indexPath.row
                    
                    let n: Int! = self.navigationController?.viewControllers.count
                    if (self.navigationController?.viewControllers[n-2] as? HomeTableViewController) != nil{
                        
                        if let cell = allArray[indexPathRow] as? TransportationTableViewCell {
                            
                            let transportationIDKey = FIRDatabase.database().reference().childByAutoId().key
                            
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
                            
                        }
                        
                    } else {
                        
                        for (index, type) in allArray.enumerate() {
                            
                            if index > 0 {
                                
                                if let selectedTransportation = allArrayTest[index - 1] as? Transportation {
                                    
                                    let cell = allArray[index] as! TransportationTableViewCell
                                    
                                    let transportationID = selectedTransportation.transportationID
                            
                                    let postID = selectedTransportation.postID
                                    
                                    let indexPath = selectedTransportation.indexPathRow
                            
                                    // Transportation Cell
                                    let type = cell.typeTextField.text ?? ""
                                    let airlineCom = cell.airlineComTextField.text ?? ""
                                    let flightNo = cell.flightNoTextField.text ?? ""
                                    let bookingRef = cell.bookingRefTextField.text ?? ""
                                    let departFrom = cell.departFromTextField.text ?? ""
                                    let arriveAt = cell.arriveAtTextField.text ?? ""
                                    let departDate = cell.departDateTextField.text ?? ""
                                    let arriveDate = cell.arriveDateTextField.text ?? ""
                                    
                                    databaseRef.child("transportations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                                        snapshot in
                                        
                                        let transportationPostID = snapshot.value!["postID"] as! String
                                        let transportationKeyID = snapshot.key
                                        
                                        let transportationOnFire: [String: AnyObject] = [
                                            
                                            "uid": userID!,
                                            "postID": postID,
                                            "transportationID": transportationKeyID,
                                            "indexPathRow": indexPath,
                                            "timestamp": timeStamp,
                                            "type": type,
                                            "airlineCom": airlineCom,
                                            "flightNo": flightNo,
                                            "bookingRef": bookingRef,
                                            "departFrom": departFrom,
                                            "arriveAt": arriveAt,
                                            "departDate": departDate,
                                            "arriveDate": arriveDate ]
                                        
                                        if transportationPostID == postID && transportationKeyID == transportationID {
                                            
                                            let updatedTransportationOnFire = ["/transportations/\(transportationKeyID)": transportationOnFire]
                                            
                                            databaseRef.updateChildValues(updatedTransportationOnFire)
                                            
                                        }
                                        
                                    })
                                }
                        
                            }
                        }
                    }
                    
                    
                    
                case .attraction:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let indexPathRow = indexPath.row
                    
                    let n: Int! = self.navigationController?.viewControllers.count
                    if (self.navigationController?.viewControllers[n-2] as? HomeTableViewController) != nil {
                        
                        if let cell = allArray[indexPathRow] as? AttractionTableViewCell {
                            
                            let attractionIDKey = FIRDatabase.database().reference().childByAutoId().key
                            
                            let name = cell.nameLabel.text ?? ""
                            let address = cell.addressLabel.text ?? ""
                            let phone = cell.phoneLabel.text ?? ""
                            let website = cell.websiteLabel.text ?? ""
                            
                            let attractionOnFire: [String: AnyObject] = [ "uid": userID!,
                                                                          "postID": postIDKey,
                                                                          "attractionID": attractionIDKey,
                                                                          "indexPathRow": indexPathRow,
                                                                          "timestamp": timeStamp,
                                                                          "name": name,
                                                                          "address": address,
                                                                          "phone": phone,
                                                                          "website": website ]
                            
                            databaseRef.child("attractions").child(attractionIDKey).setValue(attractionOnFire)
                        }
                        
                    } else {
                        
                        for (index, type) in allArray.enumerate() {
                            
                            if index > 0 {
                                
                                if let selectedAttraction = allArrayTest[index - 1] as? Attraction {
                                    
                                    let cell = allArray[index] as! AttractionTableViewCell
                                    
                                    let attractionID = selectedAttraction.attractionID
                                    
                                    let postID = selectedAttraction.postID
                                    
                                    let indexPath = selectedAttraction.indexPathRow
                                    
                                    // Attraction Cell
                                    
                                    let name = cell.nameLabel.text ?? ""
                                    let address = cell.addressLabel.text ?? ""
                                    let phone = cell.phoneLabel.text ?? ""
                                    let website = cell.websiteLabel.text ?? ""
                                    
                                    databaseRef.child("attractions").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                                        snapshot in
                                        
                                        let attractionPostID = snapshot.value!["postID"] as! String
                                        let attractionKeyID = snapshot.key
                                        
                                        
                                        let attractionOnFire: [String: AnyObject] = [
                                            
                                            "uid": userID!,
                                            "postID": postID,
                                            "attractionID": attractionKeyID,
                                            "indexPathRow": indexPath,
                                            "timestamp": timeStamp,
                                            "name": name,
                                            "address": address,
                                            "phone": phone,
                                            "website": website ]
                                        
                                        if attractionPostID == postID && attractionKeyID == attractionID {
                                            
                                            let updatedAttractionOnFire = ["/attractions/\(attractionKeyID)": attractionOnFire]
                                            
                                            databaseRef.updateChildValues(updatedAttractionOnFire)
                                            
                                        }
                                        
                                    })
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                case .accommodation:
                    
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let indexPathRow = indexPath.row
                    
                    let n: Int! = self.navigationController?.viewControllers.count
                    if (self.navigationController?.viewControllers[n-2] as? HomeTableViewController) != nil {
                        
                        if let cell = allArray[indexPathRow] as? AccommodationTableViewCell {
                            
                            let accommodationIDKey = FIRDatabase.database().reference().childByAutoId().key
                            
                            
                            // Accommodation Cell
                            let name = cell.nameLabel.text ?? ""
                            let address = cell.addressLabel.text ?? ""
                            let checkinDate = cell.checkinDateTextField.text ?? ""
                            let checkoutDate = cell.checkoutDateTextField.text ?? ""
                            let bookingRef = cell.bookingRefTextField.text ?? ""
                            
                            let accommodationOnFire: [String: AnyObject] = [ "uid": userID!,
                                                                             "postID": postIDKey,
                                                                             "accommodationID": accommodationIDKey,
                                                                             "indexPathRow": indexPathRow,
                                                                             "timestamp": timeStamp,
                                                                             "name": name,
                                                                             "address": address,
                                                                             "checkinDate": checkinDate,
                                                                             "checkoutDate": checkoutDate,
                                                                             "bookingRef": bookingRef ]
                            
                            databaseRef.child("accommodations").child(accommodationIDKey).setValue(accommodationOnFire)
                        }
                    
                            
                    } else {
                            
                            for (index, type) in allArray.enumerate() {
                                
                                if index > 0 {
                                    
                                    if let selectedAccommodation = allArrayTest[index - 1] as? Accommodation {
                                        
                                        let cell = allArray[index] as! AccommodationTableViewCell
                                        
                                        let accommodationID = selectedAccommodation.accommodationID
                                        
                                        let postID = selectedAccommodation.postID
                                        
                                        let indexPath = selectedAccommodation.indexPathRow
                                        
                                        // Accommodation Cell
                                        let name = cell.nameLabel.text ?? ""
                                        let address = cell.addressLabel.text ?? ""
                                        let checkinDate = cell.checkinDateTextField.text ?? ""
                                        let checkoutDate = cell.checkoutDateTextField.text ?? ""
                                        let bookingRef = cell.bookingRefTextField.text ?? ""
                                        
                                        databaseRef.child("accommodations").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                                            snapshot in
                                            
                                            let accommodationPostID = snapshot.value!["postID"] as! String
                                            let accommodationKeyID = snapshot.key
                                            
                                            let accommodationOnFire: [String: AnyObject] = [
                                                "uid": userID!,
                                                "postID": postID,
                                                "accommodationID": accommodationKeyID,
                                                "indexPathRow": indexPath,
                                                "timestamp": timeStamp,
                                                "name": name,
                                                "address": address,
                                                "checkinDate": checkinDate,
                                                "checkoutDate": checkoutDate,
                                                "bookingRef": bookingRef ]
                                            
                                            if accommodationPostID == postID && accommodationKeyID == accommodationID {
                                                
                                                let updatedAccommodationOnFire = ["/accommodations/\(accommodationKeyID)": accommodationOnFire]
                                                
                                                databaseRef.updateChildValues(updatedAccommodationOnFire)
                                                
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
                    
                

    
    // MARK: Picker Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            
            return countryArray.count
            
        } else if pickerView.tag == 1{
            
            return transportationTypeArray.count
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.whiteColor()
        pickerLabel.font = UIFont(name: "CourierNewPS-BoldMT", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        if pickerView.tag == 0 {
            
            pickerLabel.text = countryArray[row]
            
        } else if pickerView.tag == 1 {
            
            pickerLabel.text = transportationTypeArray[row]
            
        }
        
        return pickerLabel
        
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddTableViewCell
            cell.countryTextField.text = countryArray[row]
            
        } else if pickerView.tag == 1 {
            
            currentEditingTypeTextField?.text = transportationTypeArray[row]
            
        }
        
//        self.view.endEditing(true)
    }
    
    
    // MARK: TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
        currentEditingTypeTextField = textField
        
        if let cell = textField.superview?.superview as? AddTableViewCell {
            
            cell.startDateTextField.inputView = startDatePicker
            cell.returnDateTextField.inputView = returnDatePicker
            
            // startDatePicker.reloadInputViews()
            startDatePicker.addTarget(self, action: #selector(AddViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
            returnDatePicker.addTarget(self, action: #selector(AddViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
        }
        
        if let cell = textField.superview?.superview as? TransportationTableViewCell {
            
//            tableView.setContentOffset((CGPointMake(0, 250)), animated: true)
            
            cell.typeTextField.inputView = transportationTypePickerView
//            cell.departDateTextField.inputView = transportationDepartDatePickerView
            
//             transportationDepartDatePickerView.addTarget(self, action: #selector(AddViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        currentEditingTypeTextField = nil
        
//        tableView.setContentOffset((CGPointMake(0, 0)), animated: true)
        
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
//        else if sender == transportationDepartDatePickerView {
//            
//            let indexPath = tableView.indexPathForSelectedRow
//            if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? TransportationTableViewCell {
//            
////            if let cell = sender.superview?.superview as? TransportationTableViewCell {
//            
//                cell.departDateTextField.text = formatter.stringFromDate(sender.date)
//            
//            }
        
//        }
        
//        self.view.endEditing(true)
    }
    
    // MARK: Set Up PickerView UI
    func setUpPickerViewUI() {
        
        // Country Picker
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
        
        // Date Picker
        startDatePicker.minuteInterval = 30
        startDatePicker.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
        startDatePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        //        startDatePicker.setValue("CourierNewPS-BoldMT", forKey: "textFont")
        
        returnDatePicker.minuteInterval = 30
        returnDatePicker.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
        returnDatePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        
        // Transportation Type Picker
        transportationTypePickerView.delegate = self
        transportationTypePickerView.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
        transportationTypePickerView.showsSelectionIndicator = true
        
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
                    
                    // Edited
                    var swiftArray = allArray as NSArray as [AnyObject]
                    swiftArray.insert(swiftArray.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                    allArray.removeAllObjects()
                    allArray.addObjectsFromArray(swiftArray)
                    
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

extension AddViewController: GMSAutocompleteViewControllerDelegate {
    
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




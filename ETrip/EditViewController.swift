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

var titleCell = TitleTableViewCell()
var transportationCell = TransportationTableViewCell()

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var post: Post?
    
    
    var transportation: Transportation?
    
    var transportations = [Transportation]()
    
    var countryArray = [String]()
    var pickerView = UIPickerView()
    var startDatePicker = UIDatePicker()
    var returnDatePicker = UIDatePicker()
    
    var cellArray: [ AnyObject ] = [0]
    
    //    var datePicker : UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTransportationButton(sender: UIBarButtonItem) {
        
        cellArray.append(Transportation())
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: cellArray.count - 1, inSection: 0)], withRowAnimation: .Bottom)
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
        
        setUpPickerViewUI()
        
        
        
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
        return cellArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let type = cellArray[indexPath.row]
        
        if (type as? Transportation) != nil {
            
            let cell = NSBundle.mainBundle().loadNibNamed("TransportationTableViewCell", owner: UITableViewCell.self, options: nil).first as! TransportationTableViewCell
            
            transportationCell = cell
            return cell
            
        } else {
            
            let cellIdentifier = "titleCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TitleTableViewCell
            
            cell.startDateTextField.delegate = self
            cell.returnDateTextField.delegate = self
            
            if let post = post {
                
                cell.titleTextField.text = post.title
                cell.countryTextField.text = post.country
                cell.startDateTextField.text = post.startDate
                cell.returnDateTextField.text = post.returnDate
                
            }
            
            titleCell = cell
            cell.countryTextField.inputView = pickerView
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            self.cellArray.removeAtIndex(indexPath.row)
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
            //            let key = FIRDatabase.database().reference().childByAutoId().key
            
            let timeStamp: NSNumber = Int(NSDate().timeIntervalSince1970)
            
            // Trip Title Cell
            let title = titleCell.titleTextField.text ?? ""
            let country = titleCell.countryTextField.text ?? ""
            
            // needs to be re-designed > Date Picker
            let startDate = titleCell.startDateTextField.text ?? ""
            let returnDate = titleCell.returnDateTextField.text ?? ""
            
            // Store Trip Title in Firebase
            //            let titleOnFire: [String: AnyObject] =
            //                [ "title":
            //                    ["uid": userID!,
            //                        "timestamp": timeStamp,
            //                        "title": title,
            //                        "country": country,
            //                        "startDate": startDate,
            //                        "returnDate": returnDate ]
            //            ]
            
            //            databaseRef.child("posts").childByAutoId().setValue(titleOnFire)
            
            // Transportation Cell
            let type = transportationCell.typeTextField.text ?? ""
            let airlineCom = transportationCell.airlineComTextField.text ?? ""
            let flightNo = transportationCell.flightNoTextField.text ?? ""
            let bookingRef = transportationCell.departFromTextField.text ?? ""
            let departFrom = transportationCell.departFromTextField.text ?? ""
            let arriveAt = transportationCell.arriveAtTextField.text ?? ""
            let departDate = transportationCell.departDateTextField.text ?? ""
            let arriveDate = transportationCell.arriveDateTextField.text ?? ""
            
            // Store Transportation in Firebase
            
            let addOnFire: [String: AnyObject] =
                [ "tripTitle":
                    ["uid": userID!,
                        "timestamp": timeStamp,
                        "title": title,
                        "country": country,
                        "startDate": startDate,
                        "returnDate": returnDate ],
                  "tranportations":
                    ["userID": userID!,
                        "timestamp": timeStamp,
                        "type": type,
                        "airlineCom": airlineCom,
                        "flightNo": flightNo,
                        "bookingRef": bookingRef,
                        "departFrom": departFrom,
                        "arriveAt": arriveAt,
                        "departDate": departDate,
                        "arriveDate": arriveDate ]
            ]
            
            databaseRef.child("posts").childByAutoId().setValue(addOnFire)
            
            
            // Set the post to be passed to HomeTableViewController after the unwind segue.
            // post = Post(postID: postID, title: title, country: country, startDate: startDate, returnDate: returnDate)
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
        titleCell.countryTextField.text = countryArray[row]
    }
    
    
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        return title
        
    }
    
    // Date TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        titleCell.startDateTextField.inputView = startDatePicker
        titleCell.returnDateTextField.inputView = returnDatePicker
        //        startDatePicker.reloadInputViews()
        startDatePicker.addTarget(self, action: #selector(EditViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
        returnDatePicker.addTarget(self, action: #selector(EditViewController.updateDateField(_:)), forControlEvents: .ValueChanged)
        
    }
    
    func updateDateField(sender: UIDatePicker) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy HH:mm"
        
        if sender == startDatePicker {
            
            titleCell.startDateTextField.text = formatter.stringFromDate(sender.date)
            
        } else if sender == returnDatePicker {
            
            titleCell.returnDateTextField.text = formatter.stringFromDate(sender.date)
            
        }
    }
    
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
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

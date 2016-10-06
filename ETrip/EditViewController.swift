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

var myCell0 = TitleTableViewCell()
var myCell1 = TransportationTableViewCell()

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var post: Post?
    var transportation: Transportation?
    
    var transportations = [Transportation]()
    
    var countryArray = [String]()
    var pickerView = UIPickerView()
    var startDatePicker = UIDatePicker()
    var returnDatePicker = UIDatePicker()
    
    var cellArray: [ AnyObject ] = [38, Transportation(type: "airplane", departDate: "2016", arriveDate: "2017", departFrom: "Taipei", arriveAt: "Dubai", airlineCom: "Emirates", flightNo: "EK566", bookingRef: "hiiiii")]
    
    //    var datePicker : UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Country Picker
        for code in NSLocale.ISOCountryCodes() as [String] {
            
            let name = NSLocale.currentLocale().displayNameForKey(NSLocaleCountryCode, value: code) ?? "Country not found for code: \(code)"
            
            countryArray.append(name)
            countryArray.sortInPlace({ ( name1, name2) -> Bool in
                name1 < name2
            })
            
        }
        
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
            
            myCell1 = cell
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
            
            myCell0 = cell
            cell.countryTextField.inputView = pickerView
            
            return cell
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
            let postAutoId = databaseRef.childByAutoId().key
            
            // Trip Title Cell
            let title = myCell0.titleTextField.text ?? ""
            let country = myCell0.countryTextField.text ?? ""
            
            // needs to be re-designed > Date Picker
            let startDate = myCell0.startDateTextField.text ?? ""
            let returnDate = myCell0.returnDateTextField.text ?? ""
            
            // Store Trip Title in Firebase
            let titleOnFire: [String: AnyObject] = [ "uid": userID!,
                                                     "title": title,
                                                     "country": country,
                                                     "startDate": startDate,
                                                     "returnDate": returnDate]
            databaseRef.child("posts").child(postAutoId).setValue(titleOnFire)
            
            // Transportation Cell
            let type = myCell1.typeTextField.text ?? ""
            let airlineCom = myCell1.airlineComTextField.text ?? ""
            let flightNo = myCell1.flightNoTextField.text ?? ""
            let bookingRef = myCell1.departFromTextField.text ?? ""
            let departFrom = myCell1.departFromTextField.text ?? ""
            let arriveAt = myCell1.arriveAtTextField.text ?? ""
            let departDate = myCell1.departDateTextField.text ?? ""
            let arriveDate = myCell1.arriveDateTextField.text ?? ""
            
            // Store Transportation in Firebase
            
            let transportationOnFire: [String: AnyObject] = [ "userID": userID!,
                                                              "postID": postAutoId,
                                                              "type": type,
                                                              "airlineCom": airlineCom,
                                                              "flightNo": flightNo,
                                                              "bookingRef": bookingRef,
                                                              "departFrom": departFrom,
                                                              "arriveAt": arriveAt,
                                                              "departDate": departDate,
                                                              "arriveDate": arriveDate ]
            
            databaseRef.child("transportations").childByAutoId().setValue(transportationOnFire)
            
            
            // Set the post to be passed to HomeTableViewController after the unwind segue.
            post = Post(title: title, country: country, startDate: startDate, returnDate: returnDate)
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
        myCell0.countryTextField.text = countryArray[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        return title
        
    }
    
    // Date TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
        myCell0.startDateTextField.inputView = startDatePicker
        myCell0.returnDateTextField.inputView = returnDatePicker
        startDatePicker.reloadInputViews()
        startDatePicker.addTarget(self, action: #selector(EditViewController.startDatePickerChanged(_:)), forControlEvents: .ValueChanged)
        returnDatePicker.addTarget(self, action: #selector(EditViewController.returnDatePickerChanged(_:)), forControlEvents: .ValueChanged)
        
    }
    
    func startDatePickerChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy HH:mm"
        myCell0.startDateTextField.text = formatter.stringFromDate(sender.date)
    }
    
    func returnDatePickerChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy HH:mm"
        myCell0.returnDateTextField.text = formatter.stringFromDate(sender.date)
    }
    
    
    //    //MARK:- textFiled Delegate
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        self.pickUpDate(myCell.startDateTextField)
    //        self.pickUpDate(myCell.returnDateTextField)
    //    }
    //
    //    func pickUpDate(textField : UITextField){
    //
    //        // DatePicker
    //        self.datePicker = UIDatePicker(frame:CGRectMake(0, 0, self.view.frame.size.width, 216))
    //        self.datePicker.backgroundColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
    //        self.datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
    //        self.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
    //        self.datePicker.minuteInterval = 30
    //        textField.inputView = self.datePicker
    //
    //        // ToolBar
    //        let toolBar = UIToolbar()
    //        toolBar.barStyle = .Default
    //        toolBar.translucent = true
    //        toolBar.tintColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.5)
    //        toolBar.sizeToFit()
    //
    //        // Adding Button ToolBar
    //        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(EditViewController.doneClick))
    //        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(EditViewController.cancelClick))
    //        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    //        toolBar.userInteractionEnabled = true
    //        textField.inputAccessoryView = toolBar
    //
    //    }
    //
    //    // MARK:- Button Done and Cancel
    //
    //    func doneClick() {
    //
    //        let formatter = NSDateFormatter()
    //        formatter.dateFormat = "HH:mm EEE MMM dd, yyy"
    //        myCell.startDateTextField.text = formatter.stringFromDate(datePicker.date)
    //        myCell.startDateTextField.resignFirstResponder()
    //        myCell.returnDateTextField.text = formatter.stringFromDate(datePicker.date)
    //        myCell.returnDateTextField.resignFirstResponder()
    //
    //    }
    //
    //    func cancelClick() {
    //
    //        myCell.startDateTextField.resignFirstResponder()
    //        myCell.returnDateTextField.resignFirstResponder()
    //
    //    }
    
    
    
    
    
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

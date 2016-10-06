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

var myCell = TitleTableViewCell()

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var post: Post?
    
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
            
            let cellIdentifier = "transportationCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TransportationTableViewCell
            
            //        let transportation = transportations[indexPath.row]
            //        cell.typeLabel.text = transportation.type
            
            let infoView = NSBundle.mainBundle().loadNibNamed("TransportationTableViewCell", owner: UITableViewCell.self, options: nil).first as! TransportationTableViewCell
//            infoView.frame = cell.frame
            
            cell.addSubview(infoView)
            
            // transportation xib set up
//            let nib = UINib(nibName: "TransportationTableViewCell", bundle: nil)
//            cell.registerNib(nib, forCellReuseIdentifier: "transportationCell")
//            
            return cell
            
        } else {
            
            let cellIdentifier = "titleCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TitleTableViewCell
            
            cell.titleTextField.delegate = self
            cell.countryTextField.delegate = self
            cell.startDateTextField.delegate = self
            cell.returnDateTextField.delegate = self
            
            if let post = post {
                cell.titleTextField.text = post.title
                cell.countryTextField.text = post.country
                cell.startDateTextField.text = post.startDate
                cell.returnDateTextField.text = post.returnDate
            }
            
            myCell = cell
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
            
            let title = myCell.titleTextField.text ?? ""
            let country = myCell.countryTextField.text ?? ""
            
            // needs to be re-designed > Date Picker
            let startDate = myCell.startDateTextField.text ?? ""
            let returnDate = myCell.returnDateTextField.text ?? ""
            
            // Store in Firebase
            let databaseRef = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            let postOnFire: [String: AnyObject] = [ "uid": userID!,
                                                    "title": title,
                                                    "country": country,
                                                    "startDate": startDate,
                                                    "returnDate": returnDate]
            databaseRef.child("posts").childByAutoId().setValue(postOnFire)
            
            
            
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
        myCell.countryTextField.text = countryArray[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        return title
    }
    
    // date TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
        myCell.startDateTextField.inputView = startDatePicker
        myCell.returnDateTextField.inputView = returnDatePicker
        startDatePicker.reloadInputViews()
        startDatePicker.addTarget(self, action: #selector(EditViewController.startDatePickerChanged(_:)), forControlEvents: .ValueChanged)
        returnDatePicker.addTarget(self, action: #selector(EditViewController.returnDatePickerChanged(_:)), forControlEvents: .ValueChanged)
        
    }
    
    func startDatePickerChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy HH:mm"
        myCell.startDateTextField.text = formatter.stringFromDate(sender.date)
    }
    
    func returnDatePickerChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy HH:mm"
        myCell.returnDateTextField.text = formatter.stringFromDate(sender.date)
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

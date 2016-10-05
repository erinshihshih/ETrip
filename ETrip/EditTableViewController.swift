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

var cell = TitleTableViewCell()

class EditTableViewController: UITableViewController, UITextFieldDelegate
//UIPickerViewDataSource, UIPickerViewDelegate
{
    
    var post: Post?
    
    var countryArray = [String]()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let pickerView = UIPickerView()
//        
//        for code in NSLocale.ISOCountryCodes() as [String] {
//            
//            let id = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: code])
//            let name = NSLocale(localeIdentifier: "en_EN").displayNameForKey(NSLocaleIdentifier, value: id) ?? "Country not found for code: \(code)"
//            
//            countryArray.append(name)
//            countryArray.sortInPlace({ ( name1, name2) -> Bool in
//                name1 > name2
//            })
//            
//        }
        
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        cell.countryPickerView = UIPickerView()
//        cell.destinationTextField.inputView = pickerView

    
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "titleCell"
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TitleTableViewCell
        
        cell.titleTextField.delegate = self
        cell.destinationTextField.delegate = self
        cell.startDateTextField.delegate = self
        cell.returnDateTextField.delegate = self
        
        
        if let post = post {
            cell.titleTextField.text = post.title
            cell.destinationTextField.text = post.destination
            cell.startDateTextField.text = post.startDate
            cell.returnDateTextField.text = post.returnDate
        }
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            let title = cell.titleTextField.text ?? ""
            let destination = cell.destinationTextField.text ?? ""
            
            // needs to be re-designed > Date Picker
            let startDate = cell.startDateTextField.text ?? ""
            let returnDate = cell.returnDateTextField.text ?? ""
            
            // Store in Firebase
            let databaseRef = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            let postOnFire: [String: AnyObject] = [ "uid": userID!,
                                                    "title": title,
                                                    "destination": destination,
                                                    "startDate": startDate,
                                                    "returnDate": returnDate]
            databaseRef.child("posts").childByAutoId().setValue(postOnFire)
            
            
            
            // Set the post to be passed to HomeTableViewController after the unwind segue.
            post = Post(title: title, destination: destination, startDate: startDate, returnDate: returnDate)
        }
    }
    
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return countryArray[row]
//    }
//    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        cell.destinationTextField.text = countryArray[row]
//    }
//    
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return countryArray.count
//    }
//    
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        
//        let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
//        return title
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

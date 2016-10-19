//
//  MapViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/17.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, UISearchBarDelegate {
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
  
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func searchWithAddress(sender: AnyObject) {
        let serchController = UISearchController(searchResultsController: nil)
        serchController.searchBar.delegate = self
        self.presentViewController(serchController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        self.titleLabel.text = post?.title
        self.countryLabel.text = post?.country
        self.startDateLabel.text = post?.startDate
        self.returnDateLabel.text = post?.returnDate

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(25.042789, longitude: 121.564869, zoom: 18)
        mapView.myLocationEnabled = true
        mapView.camera = camera
        
        let currentLocation = CLLocationCoordinate2DMake(25.042789, 121.564869)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "AppWorks"
        marker.snippet = "Taipei"
        marker.map = mapView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue" {
            let detailViewController = segue.destinationViewController as! EditViewController
            
            detailViewController.post = post
            
            print("Edit the trip.")
        }
    }

}

//
//  MapViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/17.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double!
    var longitude: Double!
    
    var placeHolder: GMSMarker?
    var placeHolderView: UIImageView?
    
    @IBAction func searchWithAddress(sender: AnyObject) {

        
        // 1
        let center = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        self.placePicker = GMSPlacePicker(config: config)
        
        // 2
        placePicker.pickPlaceWithCallback { (place: GMSPlace?, error: NSError?) -> Void in
            
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                return
            }
            // 3
            if let place = place {
                
                
//                let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
//                let marker = GMSMarker(position: coordinates)
//                marker.title = place.name
//                marker.map = self.mapView
//                self.mapView.animateToLocation(coordinates)
            
            
//                let placeHolder = UIImage(named: "placeholder")!.imageWithRenderingMode(.AlwaysTemplate)
//                let markerView = UIImageView(image: placeHolder)
//                markerView.tintColor = UIColor.redColor()
//                self.placeHolderView = markerView
                
                let position = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                let marker = GMSMarker(position: position)
                marker.title = place.name
                marker.snippet = place.formattedAddress
//                marker.iconView = markerView
                marker.icon = GMSMarker.markerImageWithColor(UIColor.cyanColor())
                marker.tracksViewChanges = true
                marker.map = self.mapView
                self.placeHolder = marker
                
            } else {
                print("No place was selected")
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = post?.title
        self.countryLabel.text = post?.country
        self.startDateLabel.text = post?.startDate
        self.returnDateLabel.text = post?.returnDate
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        mapView.settings.myLocationButton = true

    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        UIView.animateWithDuration(5.0, animations: { () -> Void in
            self.placeHolderView?.tintColor = UIColor.blueColor()
            }, completion: {(finished: Bool) -> Void in
                // Stop tracking view changes to allow CPU to idle.
                self.placeHolder?.tracksViewChanges = false
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let camera = GMSCameraPosition.cameraWithLatitude(25.042789, longitude: 121.564869, zoom: 18)
        mapView.myLocationEnabled = true
        mapView.camera = camera
    
        mapView.clear()
        
//        let currentLocation = CLLocationCoordinate2DMake(25.042789, 121.564869)
//        let marker = GMSMarker(position: currentLocation)
//        marker.title = "AppWorks"
//        marker.snippet = "Taipei"
//        marker.map = mapView
        
    }
    
    
    
    //MARK: Location protocol
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        // 1
        let location:CLLocation = locations.last!
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        // 2
//        let coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
//        let marker = GMSMarker(position: coordinates)
//        marker.title = "I am here"
//        marker.map = self.mapView
//        marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 1))
     
//        self.mapView.animateToLocation(coordinates)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        
        print("An error occurred while tracking location changes : \(error.description)")
    }

    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue" {
            let detailViewController = segue.destinationViewController as! EditViewController
            
            detailViewController.post = post
            
            print("Edit the trip.")
        }
    }

}

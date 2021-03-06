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
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double!
    var longitude: Double!
    
    var placeHolder: GMSMarker?
    var placeHolderView: UIImageView?
    
    var counterMarker: Int = Int()
    var places: [CLLocationCoordinate2D] = []
    
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
                
                //                let placeHolder = UIImage(named: "placeholder")!.imageWithRenderingMode(.AlwaysTemplate)
                //                let markerView = UIImageView(image: placeHolder)
                //                markerView.tintColor = UIColor.redColor()
                //                self.placeHolderView = markerView
                
                let position = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                let marker = GMSMarker(position: position)
                marker.title = place.name
                marker.snippet = place.formattedAddress
                //                marker.iconView = markerView
                marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 1)
)
                marker.tracksViewChanges = true
                marker.map = self.mapView
                self.placeHolder = marker
                
                
                self.places.append(marker.position)
                let path = GMSMutablePath()
                for position in self.places {
                    
                    if self.places.count >= 2 {
                        
                        path.addLatitude(position.latitude, longitude: position.longitude)
                        
                    }
                }
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 5.0
                polyline.strokeColor = UIColor.cyanColor()
                polyline.geodesic = true
                polyline.map = self.mapView

                
                
                
                
                
            } else {
                print("No place was selected")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.titleLabel.text = post?.title
//        self.countryLabel.text = post?.country
//        self.startDateLabel.text = post?.startDate
//        self.returnDateLabel.text = post?.returnDate
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        mapView.settings.myLocationButton = true
        
        //        let path = GMSMutablePath()
        //        path.addLatitude(-37.81319, longitude:144.96298)
        //        path.addLatitude(-31.95285, longitude:115.85734)
        //        let polyline = GMSPolyline(path: path)
        //        polyline.strokeWidth = 10.0
        //        polyline.geodesic = true
        //        polyline.map = mapView
        
        
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
        
        //        let currentLocation = CLLocationCoordinate2DMake(25.042789, 121.564869)
        //        let marker = GMSMarker(position: currentLocation)
        //        marker.title = "AppWorks"
        //        marker.snippet = "Taipei"
        //        marker.map = mapView
        
    }
    
    
    
    //MARK: Location protocol
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
         1
        let location:CLLocation = locations.last!
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
//        let location = locations.last
//        
//        let camera = GMSCameraPosition.cameraWithLatitude((location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
//        
//        self.mapView?.animateToCameraPosition(camera)
//        
//        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        
        print("An error occurred while tracking location changes : \(error.description)")
    }
    
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        if counterMarker < 10 {
            counterMarker += 1
            let marker = GMSMarker(position: coordinate)
            marker.appearAnimation = kGMSMarkerAnimationPop
            
            marker.map = mapView
            marker.position.latitude = coordinate.latitude
            marker.position.longitude = coordinate.longitude
            marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 1))
//            print(marker.position.latitude)
//            print(marker.position.longitude)
          
            self.places.append(marker.position)
            let path = GMSMutablePath()
            for position in self.places {
                
                if self.places.count >= 2 {
                    
                    path.addLatitude(position.latitude, longitude: position.longitude)
                    
                }
            }
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5.0
            polyline.strokeColor = UIColor.cyanColor()
            polyline.geodesic = true
            polyline.map = self.mapView
            
        
    
    
        } else {
            let alert = UIAlertController(title: "Alert", message: "Too many markers! Please delete the boring places you would like to go to keep the quality of the journey.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("ok")
                
                
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        
        let alert = UIAlertController(title: "Alert", message: "Are you Sure for deleting ?!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("No Pressed")
            
            
            })
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("Yes Pressed")
            marker.map = nil
            self.counterMarker -= 1
            
            })
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        return true
    }
    
}
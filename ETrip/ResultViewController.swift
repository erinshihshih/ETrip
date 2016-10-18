//
//  ResultViewController.swift
//  ETrip
//
//  Created by Erin Shih on 2016/9/29.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

class ResultViewController: UITabBarController {
    
    var post: Post?
    var transportation: Transportation?
    var attraction: Attraction?
    
    var transportations: [Transportation] = []
    var attractions: [Attraction] = []
    
    var allArray: [Any] = [ ]
    
    var isTransportationReceived = false
    var isAttractionReceived = false
    
    enum Row {
        case transportation, attraction
    }
    
    var rows: [Row] = []
    
    var planViewController = PlannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Manager Delegate
        FirebaseManager.shared.delegate = self
        FirebaseManager.shared.fetchTransportations()
        FirebaseManager.shared.fetchAttractions()
        
        // Set up Planner View
        planViewController = self.viewControllers![0] as! PlannerViewController
        planViewController.post = post
    
        
        // Set up Map View
        let mapViewController = self.viewControllers![1] as! MapViewController
        mapViewController.post = post
        mapViewController.transportation = transportation
        mapViewController.attraction = attraction
//        mapViewController.tableView.reloadData()
        
//        sortMyArray(allArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sortMyArray(arr: [Any]) {
        
        if isTransportationReceived && isAttractionReceived {
            
        } else {
            return
        }
        
        var allIndex: [String:Int] = [ : ]
        rows = []
        
        for index in 0..<arr.count {
            
            if let card =  arr[index] as? Transportation {
                
                allIndex[String(index)] = card.indexPathRow
                
            }
            
            if let card =  arr[index] as? Attraction {
                
                allIndex[String(index)] = card.indexPathRow
                
            }
        }
        
        typealias DictSorter = ((String,Int),(String,Int)) -> Bool
        
        let indexSmallToLarge: DictSorter = { $0.1 < $1.1 }
        
        // selector
        let listSelector: (String,Int)->String = { $0.0 }
        
        // Usage
        let dict = allIndex
        
        let newArrayByIndexSmallToLarge = dict.sort(indexSmallToLarge).map(listSelector)
        
        var newArray: [Any] = []
        
        for index in 0..<newArrayByIndexSmallToLarge.count {
            
            let item = newArrayByIndexSmallToLarge[index]
            
            newArray.append(allArray[Int(item)!])
            
            if newArray[index] is Transportation{
                rows.append(.transportation)
            }
            
            if newArray[index] is Attraction{
                rows.append(.attraction)
            }
            
        }
        
        allArray = newArray
        
        planViewController.allArray = allArray
        planViewController.sortMyArray(allArray)

    }

}

extension ResultViewController: FirebaseManagerDelegate {
    
    func getPostManager(getPostManager: FirebaseManager, didGetData post: Post) {
        
    }
    
    func getTransportationManager(getTransportationManager: FirebaseManager, didGetData transportation: Transportation) {
        
        guard let postID = post?.postID else {
            print("getTransportationManager: Cannot find the postID")
            return
        }
        
        if transportation.postID == postID {
            
            self.transportations.append(transportation)
            allArray.append(transportation)
            print(allArray.count)
            isTransportationReceived = true
            self.rows.append(.transportation)
            planViewController.transportation = transportation
            
        }
        //排序
        sortMyArray(allArray)
        
        
    }
    
    func getAttractionManager(getAttractionManager: FirebaseManager, didGetData attraction: Attraction) {
        
        guard let postID = post?.postID else {
            print("getAttractionManager: Cannot find the postID")
            return
        }
        
        if attraction.postID == postID {
            
            self.attractions.append(attraction)
            allArray.append(attraction)
            print(allArray.count)
            isAttractionReceived = true
            self.rows.append(.attraction)
            planViewController.attraction = attraction
            
        }
        
        //排序
        sortMyArray(allArray)
        
    }
    
    
}


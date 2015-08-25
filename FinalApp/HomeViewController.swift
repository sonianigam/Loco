//
//  HomeViewController.swift
//  TemplateProject
//
//  Created by sonia on 7/27/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit
import MapKit
import RealmSwift


class HomeViewController: UITableViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    let locationManager = LocationManager.sharedLocationManager.locationManager
    var segueLocation: KeyLocation?
    var realm = Realm()
    
    var keyLocations: Results<KeyLocation>! {
        didSet {
            // Whenever keyLocations update, update the table view
            tableView?.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorColor = StyleConstants.defaultColor
        locationManager.requestAlwaysAuthorization()
        //println(keyLocations)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshKeyLocations", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func descending(d1: KeyLocation, d2: KeyLocation) -> Bool{
        return d1.time > d2.time
    }
    
    
    override func viewDidAppear(animated: Bool) {
        println("view did appear")
        refreshKeyLocations()
    }
    
    func refreshKeyLocations() {
        let realm = Realm()
        
        keyLocations = self.realm.objects(KeyLocation).sorted("time", ascending: false)
        
        //LOADING UP DATA FOR DEMO DAY *********************************************************************************
        
//        if keyLocations.count < 1
//        {
//            var location1 = KeyLocation()
//            location1.locationTitle = "Starbucks ☕️"
//            var location1Visit1 = Visit()
//            let location1V1C = NSDateComponents()
//            location1V1C.year = 2015
//            location1V1C.month = 8
//            location1V1C.day = 14
//            location1V1C.hour = 8
//            location1V1C.minute = 30
//            location1V1C.second = 05
//            location1Visit1.duration = 340
//            location1Visit1.date = NSCalendar.currentCalendar().dateFromComponents(location1V1C)!
//            location1.visits.append (location1Visit1)
//            
//            
//            var location2 = KeyLocation()
//            location2.locationTitle = "Home 🏡"
//            var location2Visit1 = Visit()
//            let location2V1C = NSDateComponents()
//            location2V1C.year = 2015
//            location2V1C.month = 8
//            location2V1C.day = 14
//            location2V1C.hour = 17
//            location2V1C.minute = 27
//            location2V1C.second = 25
//            location2Visit1.duration = 7258
//            location2Visit1.date = NSCalendar.currentCalendar().dateFromComponents(location2V1C)!
//            location2.visits.append (location2Visit1)
//            
//            var location2Visit2 = Visit()
//            let location2V2C = NSDateComponents()
//            location2V2C.year = 2015
//            location2V2C.month = 8
//            location2V2C.day = 14
//            location2V2C.hour = 23
//            location2V2C.minute = 04
//            location2V2C.second = 48
//            location2Visit2.duration = 32400
//            location2Visit2.date = NSCalendar.currentCalendar().dateFromComponents(location2V2C)!
//            location2.visits.append (location2Visit2)
//            
//            var location2Visit3 = Visit()
//            let location2V3C = NSDateComponents()
//            location2V3C.year = 2015
//            location2V3C.month = 8
//            location2V3C.day = 13
//            location2V3C.hour = 21
//            location2V3C.minute = 58
//            location2V3C.second = 52
//            location2Visit3.duration = 31400
//            location2Visit3.date = NSCalendar.currentCalendar().dateFromComponents(location2V3C)!
//            location2.visits.append (location2Visit3)
//            
//            
//            var location3 = KeyLocation()
//            location3.locationTitle = "Golf Course ⛳️"
//            var location3Visit1 = Visit()
//            let location3V1C = NSDateComponents()
//            location3V1C.year = 2015
//            location3V1C.month = 8
//            location3V1C.day = 14
//            location3V1C.hour = 12
//            location3V1C.minute = 45
//            location3V1C.second = 10
//            location3Visit1.duration = 14400
//            location3Visit1.date = NSCalendar.currentCalendar().dateFromComponents(location3V1C)!
//            location3.visits.append (location3Visit1)
//            
//            
//            var location4 = KeyLocation()
//            location4.locationTitle = "Library 📚"
//            var location4Visit1 = Visit()
//            let location4V1C = NSDateComponents()
//            location4V1C.year = 2015
//            location4V1C.month = 8
//            location4V1C.day = 14
//            location4V1C.hour = 1
//            location4V1C.minute = 17
//            location4V1C.second = 10
//            location4Visit1.duration = 6000
//            location4Visit1.date = NSCalendar.currentCalendar().dateFromComponents(location4V1C)!
//            location4.visits.append (location4Visit1)
//            
//            
//            realm.write()
//                {
//                    realm.add(location1)
//                    realm.add(location2)
//                    realm.add(location3)
//                    realm.add(location4)
//            }
//        }
        
        keyLocations = self.realm.objects(KeyLocation).sorted("time", ascending: false)
        
        
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    // MARK: segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "segueToLocationDisplay" {
            let locationDisplayViewController: LocationDisplayViewController = segue.destinationViewController as! LocationDisplayViewController
            locationDisplayViewController.keyLocation = segueLocation
            locationDisplayViewController.homeViewController = self
        }
        
        if segue.identifier == "segueToNewLocation" {
            if keyLocations.count == 20
            {
                let alertController = UIAlertController(
                    title: "Oops!",
                    message: "You can only track 20 regions at a time",
                    preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                alertController.view.tintColor = StyleConstants.defaultColor
                presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
}

// MARK: ********************************************************************************************************


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableCell", forIndexPath: indexPath) as! HomeTableCellTableViewCell
        let row = indexPath.row
        let keyLocation = keyLocations[row]
        
        cell.configureCellWithKeyLocation(keyLocation)
        cell.configureCellWithTime(keyLocation)
        
        if keyLocations[row].inside == true {
            cell.backgroundColor = UIColor(rgb: 0xF6E5FF)
        }
        else
        {
            cell.backgroundColor = nil
        }
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(keyLocations?.count ?? 0)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if (editingStyle == .Delete) {
            let keyLocation = keyLocations[indexPath.row]
            stopMonitoringTrackedRegion(keyLocation)
            let realm = Realm()
            realm.write() {
                realm.delete(keyLocation)
            }
            
            tableView.reloadData()
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueLocation = keyLocations[indexPath.row]
        self.performSegueWithIdentifier("segueToLocationDisplay", sender: nil)
    }
    
    //MARK: Tracking ************************************************************************************
    
    
    func stopMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == trackedRegion.locationTitle {
                    locationManager.stopMonitoringForRegion(circularRegion)}}
        }
    }
    
}







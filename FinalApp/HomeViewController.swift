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
    
    var userLocation = CLLocation()
    let manager = CLLocationManager()
    var entryDate = NSDate()
    var exitDate = NSDate()
    var timeInterval = Double()
    
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
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestAlwaysAuthorization()
        
        func loadList(notification: NSNotification)
        {
            viewDidAppear(true)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
        
        
        let realm = Realm()
        keyLocations = realm.objects(KeyLocation)
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let realm = Realm()
        keyLocations = realm.objects(KeyLocation)
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableCell", forIndexPath: indexPath) as! HomeTableCellTableViewCell
        let row = indexPath.row
        let keyLocation = keyLocations[row]
        cell.configureCellWithKeyLocation(keyLocation)
        cell.configureCellWithTime(keyLocation)
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
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            if keyLocations.count == 0
            {
                manager.stopMonitoringSignificantLocationChanges()
            }
            
            tableView.reloadData()
            
        }
    }
    
}

extension HomeViewController: CLLocationManagerDelegate
{
    func setTrackedRegion(trackedRegion: KeyLocation) -> CLCircularRegion {
        
        var center = CLLocationCoordinate2D(latitude: trackedRegion.latitude, longitude: trackedRegion.longitude)
        var radius = CLLocationDistance(0.15)
        let region = CLCircularRegion(center: center, radius: radius, identifier: trackedRegion.locationTitle)
        return region
    }
    
    func startMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        let region = setTrackedRegion(trackedRegion)
        manager.startMonitoringForRegion(region)
    }
    
    func stopMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        for region in manager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == trackedRegion.locationTitle {
                    manager.stopMonitoringForRegion(circularRegion)}}
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        NSLog("Location manager failed with error: %@", error)
        if error.domain == kCLErrorDomain && CLError(rawValue: error.code) == CLError.Denied {
            //user denied location services so stop updating manager
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        userLocation = locations.last as! CLLocation
        println("Location Manager did upidate location")
    }
    
    func handleRegionEntranceEvent(region: CLRegion!)
    {
        entryDate = NSDate()
        println("entry date ----> \(entryDate)")
        
    }
    
    func handleRegionExitEvent(region: CLRegion!)
    {
        let realm = Realm()
        exitDate = NSDate()
        println(exitDate)
        timeInterval = exitDate.timeIntervalSinceDate(entryDate)
        
        realm.write(){
            
            for trackedRegion in self.keyLocations {
                if let keyLocation = trackedRegion as? KeyLocation {
                    if trackedRegion.locationTitle == region.identifier {
                        trackedRegion.time += self.timeInterval
                        println("tracked region ---> \(trackedRegion.time)")
                    }
                }
            }
            
            println("time interval ---> \(self.timeInterval)")
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if region is CLCircularRegion {
            handleRegionEntranceEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if region is CLCircularRegion {
            handleRegionExitEvent(region)
        }
    }
}





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
    
    var userLocation = CLLocation()
    var locationManager = CLLocationManager()
    var entryDate = NSDate()
    var exitDate = NSDate()
    var timeInterval = Double()
    var LocManager = LocationManager()
    var segueLocation: KeyLocation?
    
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
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        userLocation = LocManager.currentLocation
        
        
        func loadList(notification: NSNotification)
        {
            viewDidAppear(true)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
        let realm = Realm()
        keyLocations = realm.objects(KeyLocation)
        tableView.reloadData()
//
//        //pull to refresh
//        
//        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//        
//        func refresh(sender:AnyObject)
//        {
//            
//            viewDidAppear(true)
//            self.refreshControl?.endRefreshing()
//        }

        
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
    
    // MARK: segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        
        if segue.identifier == "segueToNewLocation"
            
        {
            let newLocationViewController: NewLocationViewController = segue.destinationViewController as! NewLocationViewController
            println(newLocationViewController)
            newLocationViewController.homeViewController = self
            
        }
        
        if segue.identifier == "segueToLocationDisplay"
            
        {
            let locationDisplayViewController: LocationDisplayViewController = segue.destinationViewController as! LocationDisplayViewController
            println(locationDisplayViewController)
            locationDisplayViewController.keyLocation = segueLocation
            locationDisplayViewController.homeViewController = self
            
        }
        
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
            
            tableView.reloadData()
            
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueLocation = keyLocations[indexPath.row]
        self.performSegueWithIdentifier("segueToLocationDisplay", sender: nil)
    }
}

extension HomeViewController: CLLocationManagerDelegate
{
    func setTrackedRegion(trackedRegion: KeyLocation) -> CLCircularRegion {
        println("this is the KeyLocation coming in ---> \(trackedRegion)")
        var center = CLLocationCoordinate2D(latitude: trackedRegion.latitude, longitude: trackedRegion.longitude)
        var radius = CLLocationDistance(0.001)
        var region = CLCircularRegion(center: center, radius: radius, identifier: trackedRegion.locationTitle)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func startMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        println(KeyLocation)
        var region = setTrackedRegion(trackedRegion)
        println(region)
        locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == trackedRegion.locationTitle {
                    locationManager.stopMonitoringForRegion(circularRegion)}}
        }
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
        println("exit date ---->\(exitDate)")
        timeInterval = exitDate.timeIntervalSinceDate(entryDate)
        
        realm.write(){
            
            for trackedRegion in self.keyLocations {
                if let keyLocation = trackedRegion as? KeyLocation {
                    if trackedRegion.locationTitle == region.identifier {
                        trackedRegion.time += self.timeInterval
                        println("total duration ---> \(trackedRegion.time)")
                    }
                }
            }
            
            println("time interval ---> \(self.timeInterval)")
        }
    }
    
   
    
    
        
}





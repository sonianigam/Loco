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
    var keyLocations: Results<KeyLocation>! {
        didSet {
            // Whenever keyLocations update, update the table view
            tableView?.reloadData()
        }
    }
    var newLocations = [KeyLocation]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorColor = StyleConstants.defaultColor
        locationManager.requestAlwaysAuthorization()
        viewDidAppear(true)
        println(keyLocations)
        
    }
    
    func descending(d1: KeyLocation, d2: KeyLocation) -> Bool{
        return d1.time > d2.time
    }
    
    
    override func viewDidAppear(animated: Bool) {
        println("view did appear")
        let realm = Realm()
        keyLocations = realm.objects(KeyLocation)
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
            println(locationDisplayViewController)
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





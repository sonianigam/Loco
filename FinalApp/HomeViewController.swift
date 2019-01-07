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


class HomeViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    let locationManager = LocationManager.sharedLocationManager.locationManager
    var segueLocation: KeyLocation?
    var realm = try! Realm()
    
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
    }
    
    func descending(d1: KeyLocation, d2: KeyLocation) -> Bool{
        return d1.time > d2.time
    }

    override func viewDidAppear(_ animated: Bool) {
        refreshKeyLocations()
    }
    
    func refreshKeyLocations() {
        //LOADING UP DATA FOR DEMO DAY *********************************************************************************
        
//            var location1 = KeyLocation()
//            location1.locationTitle = "Starbucks ☕️"
//            var location1Visit1 = Visit()
//            var location1V1C = DateComponents()
//            location2V1C.year = 2015
//            location2V1C.month = 8
//            location1V1C.day = 14
//            location1V1C.hour = 8
//            location1V1C.minute = 30
//            location1V1C.second = 05
//            location1Visit1.duration = 340
//            location1Visit1.date = Calendar.current.dateComponents(location1V1C)!
//            location1.visits.append (location1Visit1)
            
            
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
//            location2Visit1.date = Calendar.current.dateComponents(location2V1C)!
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
//            location2Visit2.date = Calendar.current.dateComponents(location2V2C)!
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
//            location2Visit3.date = Calendar.current.dateComponents(location2V3C)!
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
//            location3Visit1.date = Calendar.current.dateComponents(location3V1C)!
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
//            location4Visit1.date = Calendar.current.dateFromComponents(location4V1C)!
//            location4.visits.append (location4Visit1)
            
            
//            try! realm.write()
//                {
//                    realm.add(location1)
////                    realm.add(location2)
////                    realm.add(location3)
////                    realm.add(location4)
//            }

        print(Realm.Configuration.defaultConfiguration.fileURL!)
        keyLocations = self.realm.objects(KeyLocation.self).sorted(byKeyPath: "time", ascending: false)
        
        tableView.reloadData()
    }
    
    // MARK: segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToLocationDisplay" {
            let locationDisplayViewController: LocationDisplayViewController = segue.destination as! LocationDisplayViewController
            locationDisplayViewController.keyLocation = segueLocation
            locationDisplayViewController.homeViewController = self
        }
        
        if segue.identifier == "segueToNewLocation" {
            if keyLocations.count == 20
            {
                let alertController = UIAlertController(
                    title: "Oops!",
                    message: "You can only track 20 regions at a time",
                    preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alertController.view.tintColor = StyleConstants.defaultColor
                present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
}

// MARK: ********************************************************************************************************


extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath as IndexPath) as! HomeTableCellTableViewCell
        let row = indexPath.row
        let keyLocation = keyLocations[row]
        
        cell.configureCellWithKeyLocation(aKeyLocation: keyLocation)
        cell.configureCellWithTime(aKeyLocation: keyLocation)
        
        if keyLocations[row].inside == true {
            cell.backgroundColor = UIColor(rgb: 0xF6E5FF)
        }
        else
        {
            cell.backgroundColor = nil
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(keyLocations?.count ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let keyLocation = keyLocations[indexPath.row]
            stopMonitoringTrackedRegion(trackedRegion: keyLocation)
            let realm = try! Realm()
            try! realm.write() {
                realm.delete(keyLocation)
            }
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueLocation = keyLocations[indexPath.row]
        self.performSegue(withIdentifier: "segueToLocationDisplay", sender: nil)
    }
    
    //MARK: Tracking ************************************************************************************
    
    
    func stopMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == trackedRegion.locationTitle {
                    locationManager.stopMonitoring(for: circularRegion)}}
        }
    }
    
}

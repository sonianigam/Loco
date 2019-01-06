//
//  NewLocationManager.swift
//  FinalApp
//
//  Created by sonia on 8/7/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

typealias userCurrentLocationClosure = (CLLocation?, NSError?) -> Void
private let kUpdateAddressLabels = "AddressHasUpdated"

class LocationManager: NSObject {
    
    static let sharedLocationManager = LocationManager()
    var currentLocationClosure: userCurrentLocationClosure?
    var locationAddress: String = "looking for your location"
    let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var currentLocation = CLLocation()
    //    var entryDate = NSDate()
    var entryDates = Dictionary<String,NSDate>()
    //    var exitDate = NSDate()
    var timeInterval = Double()
    var keyLocations: Results<KeyLocation>!
    
    var userLocation: CLLocation = CLLocation() {
        didSet {
            print("just changed the users location")
            updateLocationAddress(aLocation: userLocation)
        }
    }
    
    override init() {
        super.init()
        
        print("LocationManager singleton accessesed")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        loadPersistedEntryDates()
        
        print(locationManager.monitoredRegions)
        
    }
    
    func getUserLocationWithClosure(locationClosure: @escaping userCurrentLocationClosure) {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
        } else {
            print("i guess location services are not enabled :(")
        }
        currentLocationClosure = locationClosure
    }
    
    func updateLocationAddress(aLocation: CLLocation!) {
        geocoder.reverseGeocodeLocation(aLocation, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            guard let _placemarks = placemarks else { return }
            
            guard let aPlacemark = _placemarks.last else { return }
            if aPlacemark.subThoroughfare == nil {
                self.locationAddress = "finding your address..."
            } else {
                self.locationAddress = "\(aPlacemark.subThoroughfare) \(aPlacemark.thoroughfare) \(aPlacemark.subAdministrativeArea)"
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateAddressLabels), object: nil)
        })
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager!, didFailWithError error: Error?) {
        guard let _error = error as? CLError else { return }
        // call closure here too....
        
        print("Location manager failed with error: \(error)")
        if _error.code == CLError.denied {
            //user denied location services so stop updating manager
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        print("Monitoring failed for region with identifier: \(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var aLocation = locations.last as! CLLocation
        locationManager.stopUpdatingLocation()
        currentLocation = aLocation
        currentLocationClosure?(aLocation, nil)
        print("Location Manager did update location")
    }
    
    //    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
    //        if state == CLRegionState.Inside
    //        {
    //            "region entrance event is handled"
    //            locationManager(locationManager, didEnterRegion: region)
    //        }
    //    }
    
    
    func persistEntryDates() {
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("data.plist")
        
        let temp:NSDictionary = entryDates as NSDictionary
        temp.write(toFile: path, atomically: true)
    }
    
    func loadPersistedEntryDates()
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let path = documentsDirectory.appendingPathComponent("data.plist")
        
        if let saved = NSDictionary(contentsOfFile: path)
        { entryDates = saved as! [String: NSDate]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        handleRegionEntranceEvent(region: region)
        
        //            homeViewController = HomeViewController()
        //            homeViewController!.handleRegionEntranceEvent(region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        handleRegionExitEvent(region: region)
        //            homeViewController = HomeViewController()
        //            homeViewController!.handleRegionExitEvent(region)
        
    }
    
    
    func handleRegionEntranceEvent(region: CLRegion!)
    {
        let realm = try! Realm()
        print("set the entry date")
        entryDates[region.identifier] = NSDate()
        keyLocations = realm.objects(KeyLocation.self)
        try! realm.write() {
            for trackedRegion in self.keyLocations! {
                let keyLocation = trackedRegion as KeyLocation
                if keyLocation.locationTitle == region.identifier {
                    keyLocation.inside = true
                    print("inside -----> \(keyLocation.inside)")
                }
                    
                else
                {
                    keyLocation.inside = false
                    print("sets false")
                }
            }
        }
        
        print("entry date ----> \(entryDates[region.identifier])")
        
        
        persistEntryDates()
    }
    
    func handleRegionExitEvent(region: CLRegion!)
    {
        
        let realm = try! Realm()
        if let entryDate = entryDates[region.identifier] {
            let exitDate = NSDate();
            let timeInterval = exitDate.timeIntervalSince(entryDate as Date)
            var visit = Visit()
            visit.date = entryDate
            visit.duration = timeInterval
            keyLocations = realm.objects(KeyLocation.self)
            
            if visit.duration < 90
            {
                try! realm.write()
                    {
                        for trackedRegion in self.keyLocations {
                            let keyLocation = trackedRegion as KeyLocation
                            if keyLocation.locationTitle == region.identifier {
                                
                                keyLocation.inside = false
                            }
                        }
                }
            }
                
            else
            {
                try! realm.write(){
                    for trackedRegion in self.keyLocations {
                        let keyLocation = trackedRegion as KeyLocation
                        if keyLocation.locationTitle == region.identifier {
                            keyLocation.time += timeInterval
                            keyLocation.inside = false
                            keyLocation.visits.append(visit)
                            print("new visit -----> \(visit)")
                            print("total duration ---> \(keyLocation.time)")
                            print("exit date ------> \(exitDate)")
                            print("entry date upon exit --------> \(entryDate)")
                            print(timeInterval)
                            print("inside -----> \(keyLocation.inside)")
                            
                        }
                        
                    }
                }
            }
        }
       
        
    }
}

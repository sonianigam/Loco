//
//  NewLocationViewController.swift
//  TemplateProject
//
//  Created by sonia on 7/27/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift
import Foundation

class NewLocationViewController: UITableViewController {
    
    // MARK: vars ***********************************************************************
    
    enum MKUserTrackingMode : Int {
        case None
        case Follow
        case FollowWithHeading
    }
    
    let sharedLocation = LocationManager.sharedLocationManager
    var setLocation = KeyLocation()
    var searchTableViewController: SearchTableViewController?
    var placeholderLabel : UILabel!
    var searchController: UISearchController!
    var trackButton: UIButton!
    let locationManager = LocationManager.sharedLocationManager.locationManager
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userGeneratedName: UITextField!
    
    // MARK: ************************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.setUserTrackingMode(.Follow, animated: true)
        self.tableView.separatorColor = StyleConstants.defaultColor
        addLabelForTextViewPlaceholderText()
        setupSearchController()
        
        sharedLocation.getUserLocationWithClosure { (aLocation, error) -> Void in
            if (error != nil) {
                println("there was an error updating current location")
                return
            }
            // ponder this: when this VC opens the user's current location is set, but if they move the current location will not be updated.
            // in the future, if the user does not set a specific address via the search bar, find a way to make sure the address is updated
            // use a boolean in the search controller to indicate -  just a thought
            global.setItem = MKMapItem(placemark: MKPlacemark(coordinate: self.sharedLocation.currentLocation.coordinate, addressDictionary: nil))
            //println("-------> \(global.setItem)")
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trackButtonTapped(sender: AnyObject) {
        
        let isAuth = checkForLocationAuth()
        
        if userGeneratedName.text == "" {
            let alertController = UIAlertController(
                title: "Oops!",
                message: "Please enter your location's name",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertController.view.tintColor = StyleConstants.defaultColor
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            var realm = Realm()
            setLocation.locationTitle = userGeneratedName.text
            setLocation.notes = textView.text
            setLocation.longitude = global.setItem.placemark.coordinate.longitude
            setLocation.latitude = global.setItem.placemark.coordinate.latitude
            setLocation.address = "\(global.setItem.placemark.subThoroughfare) \(global.setItem.placemark.thoroughfare), \(global.setItem.placemark.locality), \(global.setItem.placemark.postalCode), \(global.setItem.placemark.administrativeArea)"
            setLocation.time = 0
            realm.write() {
                realm.add(self.setLocation)
            }
            
            startMonitoringTrackedRegion(setLocation)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    
    
    // LETS NOT FORGET ABOUT THIS!!!!!!!  *********************************
    
    
    //            homeViewController!.startMonitoringTrackedRegion(setLocation)
    
    //            let aBool = global.setItem.placemark.coordinate as CLLocationCoordinate2D == sharedLocation.currentLocation.coordinate as CLLocationCoordinate2D
    //            if aBool {
    //                let currentRegion = homeViewController!.setTrackedRegion(setLocation)
    //                homeViewController!.handleRegionEntranceEvent(currentRegion)
    //            }
    
    
    //    func updateSearchResultsForSearchController(searchController: UISearchController){
    //
    //    }
    
    
    //        func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    //            mapView.showsUserLocation = status == .AuthorizedAlways
    //
    //        }
    
    func checkForLocationAuth() -> Bool{
        if CLLocationManager.authorizationStatus() == .Denied {
            sharedLocation.locationManager.requestAlwaysAuthorization()
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to track locations, please open settings and set Loco's location access to 'Always'.",
                preferredStyle: .Alert)
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
            alertController.addAction(openAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
        
    }
    
    
    
    //MARK: initiate tracking **************************************************************************************
    
    func setTrackedRegion(trackedRegion: KeyLocation) -> CLCircularRegion {
        println("this is the KeyLocation coming in ---> \(trackedRegion)")
        var center = CLLocationCoordinate2D(latitude: trackedRegion.latitude, longitude: trackedRegion.longitude)
        var radius = CLLocationDistance(10.0)
        var region = CLCircularRegion(center: center, radius: radius, identifier: trackedRegion.locationTitle)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func startMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        var region = setTrackedRegion(trackedRegion)
        println("inside this region")
       // locationManager.requestStateForRegion(region)
        locationManager.startMonitoringForRegion(region)

        if region.containsCoordinate(self.sharedLocation.currentLocation.coordinate)
        {
            sharedLocation.locationManager(locationManager, didEnterRegion: region)
            
        }
        
        //locationManager.startMonitoringForRegion(region)
        
    }
    
    
    //MARK: ui elements **************************************************************************
    
    func setupSearchController() {
        let searchTableViewController = SearchTableViewController()
        searchTableViewController.tableView.delegate = searchTableViewController
        searchTableViewController.tableView.dataSource = searchTableViewController
        searchTableViewController.newLocationViewController = self
        searchTableViewController.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "searchCell")
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.searchResultsUpdater = searchTableViewController
        searchController.delegate = searchTableViewController
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.searchBar.placeholder = "change location"
        searchController.searchBar.tintColor = StyleConstants.defaultColor
        searchController.searchBar.returnKeyType = UIReturnKeyType.Search
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.showsCancelButton = false
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.tintColor = StyleConstants.defaultColor
        
        var textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = StyleConstants.defaultColor
    }
    
    func addLabelForTextViewPlaceholderText() {
        placeholderLabel = UILabel()
        placeholderLabel.text = " enter additional notes about your location"
        placeholderLabel.sizeToFit()
        placeholderLabel.font = UIFont( name: "Helvetica Neue", size: 16)
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, textView.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.22)
    }
    
    
}

extension NewLocationViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Purple
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}


extension NewLocationViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = count(textView.text) != 0
        textView.textColor = StyleConstants.defaultColor
        textView.font = UIFont(name: "Helvetica Neue", size: 16)
    }
    
}

extension NewLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userGeneratedName.resignFirstResponder()
        return true;
    }
    
}








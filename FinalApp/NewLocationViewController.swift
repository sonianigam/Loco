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

class NewLocationViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UITextFieldDelegate, UITextViewDelegate {
    
    var setLocation = KeyLocation()
    let locationManager = CLLocationManager()
    var searchTableViewController: SearchTableViewController?
    var placeholderLabel : UILabel!
    var searchController: UISearchController!
    var trackButton: UIButton!
    var homeViewController: HomeViewController?

    @IBOutlet weak var textView: UITextView!
    
    @IBAction func trackButtonTapped(sender: AnyObject) {
        var realm = Realm()
        
        setLocation.locationTitle = userGeneratedName.text
        setLocation.notes = textView.text
        setLocation.longitude = global.setItem.placemark.coordinate.longitude
        setLocation.latitude = global.setItem.placemark.coordinate.latitude
        setLocation.address = "\(global.setItem.placemark.subThoroughfare) \(global.setItem.placemark.thoroughfare), \(global.setItem.placemark.locality), \(global.setItem.placemark.postalCode), \(global.setItem.placemark.administrativeArea)"
        setLocation.time = 0
       

        if CLLocationManager.authorizationStatus() == .Denied {
            
            locationManager.requestAlwaysAuthorization()
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
        }
        
        if setLocation.locationTitle == ""
        {
            let alertController = UIAlertController(
                title: "Oops!",
                message: "Please enter your location's name",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertController.view.tintColor = StyleConstants.defaultColor
            presentViewController(alertController, animated: true, completion: nil)
        }
            
        else {
            realm.write() {
                realm.add(self.setLocation)
            }
            
            homeViewController!.startMonitoringTrackedRegion(setLocation)
            
            
            if global.setItem.placemark.coordinate.latitude == homeViewController!.userLocation.coordinate.latitude && global.setItem.placemark.coordinate.longitude == homeViewController!.userLocation.coordinate.longitude
            {
                let currentRegion = homeViewController!.setTrackedRegion(setLocation)
                homeViewController!.handleRegionEntranceEvent(currentRegion)
            }
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userGeneratedName: UITextField!
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userGeneratedName.resignFirstResponder()
        return true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(self)
        textView.delegate = self
        mapView.delegate = self
        userGeneratedName.delegate = self
        
        func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            mapView.showsUserLocation = status == .AuthorizedAlways
            
        }
        
        global.setItem = MKMapItem(placemark: MKPlacemark(coordinate: homeViewController!.userLocation.coordinate, addressDictionary: nil))

        self.mapView.setUserTrackingMode(.Follow, animated: true)
        self.tableView.separatorColor = StyleConstants.defaultColor
        
        placeholderLabel = UILabel()
        placeholderLabel.text = " enter additional notes about your location"
        placeholderLabel.sizeToFit()
        placeholderLabel.font = UIFont( name: "Helvetica Neue", size: 16)
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, textView.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.22)
        setupSearchController()
        
    }
    
    enum MKUserTrackingMode : Int {
        case None
        case Follow
        case FollowWithHeading
    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
//        println(touches)
//        println("test")
//        self.textView.endEditing(true)
//    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = count(textView.text) != 0
        textView.textColor = StyleConstants.defaultColor
        textView.font = UIFont(name: "Helvetica Neue", size: 16)
    }
    
    
    //MARK: -SearchController
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NewLocationViewController: MKMapViewDelegate{
    
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










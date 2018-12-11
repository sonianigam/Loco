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
        
        self.mapView.setUserTrackingMode(.follow, animated: true)
        self.tableView.separatorColor = StyleConstants.defaultColor
        addLabelForTextViewPlaceholderText()
        setupSearchController()
        
        sharedLocation.getUserLocationWithClosure { (aLocation, error) -> Void in
            if (error != nil) {
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
                preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alertController.view.tintColor = StyleConstants.defaultColor
            present(alertController, animated: true, completion: nil)
        } else {
            var realm = try! Realm()
            setLocation.locationTitle = userGeneratedName.text!
            setLocation.notes = textView.text
            setLocation.longitude = global.setItem.placemark.coordinate.longitude
            setLocation.latitude = global.setItem.placemark.coordinate.latitude
            setLocation.address = "\(global.setItem.placemark.subThoroughfare) \(global.setItem.placemark.thoroughfare), \(global.setItem.placemark.locality), \(global.setItem.placemark.postalCode), \(global.setItem.placemark.administrativeArea)"
            setLocation.time = 0
            try! realm.write() {
                realm.add(self.setLocation)
            }
            
            startMonitoringTrackedRegion(trackedRegion: setLocation)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    
    func checkForLocationAuth() -> Bool{
        if CLLocationManager.authorizationStatus() == .denied {
            sharedLocation.locationManager.requestAlwaysAuthorization()
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to track locations, please open settings and set Loco's location access to 'Always'.",
                preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
        
    }
    
    
    
    //MARK: initiate tracking **************************************************************************************
    
    func setTrackedRegion(trackedRegion: KeyLocation) -> CLCircularRegion {
        print("this is the KeyLocation coming in ---> \(trackedRegion)")
        let center = CLLocationCoordinate2D(latitude: trackedRegion.latitude, longitude: trackedRegion.longitude)
        let radius = CLLocationDistance(10.0)
        let region = CLCircularRegion(center: center, radius: radius, identifier: trackedRegion.locationTitle)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func startMonitoringTrackedRegion (trackedRegion: KeyLocation)
    {
        var region = setTrackedRegion(trackedRegion: trackedRegion)
        print("inside this region")
       // locationManager.requestStateForRegion(region)
        locationManager.startMonitoring(for: region)

        if region.contains(self.sharedLocation.currentLocation.coordinate)
        {
            sharedLocation.locationManager(locationManager, didEnterRegion: region)
        }
                
    }
    
    
    //MARK: ui elements **************************************************************************
    
    func setupSearchController() {
        let searchTableViewController = SearchTableViewController()
        searchTableViewController.tableView.delegate = searchTableViewController
        searchTableViewController.tableView.dataSource = searchTableViewController
        searchTableViewController.newLocationViewController = self
        searchTableViewController.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "searchCell")
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.searchResultsUpdater = searchTableViewController
        searchController.delegate = searchTableViewController
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.searchBar.placeholder = "change location"
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = StyleConstants.defaultColor
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.showsCancelButton = false
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.tintColor = StyleConstants.defaultColor
        
        var textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = StyleConstants.defaultColor
    }
    
    func addLabelForTextViewPlaceholderText() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "enter additional notes or goals"
        placeholderLabel.sizeToFit()
        placeholderLabel.font = UIFont( name: "Helvetica Neue", size: 16)
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint.init(x: 5, y: textView.font!.pointSize / 2)

        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.22)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
}

extension NewLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .purple
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}


extension NewLocationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count != 0
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

extension NewLocationViewController {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.resignFirstResponder()
    }
}

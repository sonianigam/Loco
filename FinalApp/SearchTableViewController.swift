//
//  SearchTableViewController.swift
//  FinalApp
//
//  Created by sonia on 7/27/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchTableViewController: UITableViewController, UISearchControllerDelegate {
    var locationManager = CLLocationManager()
    var searchController: UISearchController!
    var results = [AnyObject]()
    var newLocationViewController: NewLocationViewController?
    var annotation: MKAnnotation!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    var homeViewController: HomeViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = StyleConstants.defaultColor
        // println(manager.monitoredRegions)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath as IndexPath) as! UITableViewCell
        let mapItem = results[indexPath.row] as! MKMapItem
        cell.textLabel?.text = "\(mapItem.placemark.subThoroughfare) \(mapItem.placemark.thoroughfare), \(mapItem.placemark.locality), \(mapItem.placemark.postalCode) \(mapItem.placemark.administrativeArea)"
        cell.textLabel?.textColor = UIColor .gray
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem = results[indexPath.row] as! MKMapItem
        global.setItem = mapItem
        
        //remove prior annotations
        if newLocationViewController!.mapView.annotations.count != 0 {
            newLocationViewController!.mapView.removeAnnotations(newLocationViewController!.mapView.annotations)
        }
        
        //set up new annotation
        self.pointAnnotation = MKPointAnnotation()
        
        self.pointAnnotation.title = mapItem.description
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        newLocationViewController?.mapView.centerCoordinate = self.pointAnnotation.coordinate
        newLocationViewController?.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        newLocationViewController?.searchController.searchBar.text = mapItem.name
        
        //automatic zoom into new annotation
        let zoomRegion: MKCoordinateRegion = MKCoordinateRegion(center: self.pointAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        newLocationViewController?.mapView.setRegion(zoomRegion, animated: true)
        
        //clear prior search results
        self.results.removeAll(keepingCapacity: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        if (self.results.isEmpty)
        {
            var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
            alert.show()
            return
        }
    }
}


//MARK: -Search **************************************************************************************************


extension SearchTableViewController : UISearchResultsUpdating, UISearchBarDelegate, MKMapViewDelegate {
    
    func updateSearchResults(for searchController: UISearchController)
    {
        
        let aRequest = MKLocalSearch.Request()
        aRequest.naturalLanguageQuery = searchController.searchBar.text
        
        //if current location is not set this throws an error
        
        func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            if status == .authorizedAlways
            {
                // aRequest.region = MKCoordinateRegionMakeWithDistance(homeViewController!.userLocation.coordinate, 32187, 32187)
            }
        }
        
        
        let localSearch = MKLocalSearch(request: aRequest)
        localSearch.start { (searchResponse, error) -> Void in
            
            if (error == nil) {
                self.results = searchResponse?.mapItems ?? []
                self.tableView.reloadData()
            }
        }
    }
    
}

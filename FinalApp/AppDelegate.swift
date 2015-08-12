//
//  AppDelegate.swift
//  FinalApp
//
//  Created by sonia on 7/27/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    
    var window: UIWindow?
    let sharedLocation = LocationManager.sharedLocationManager
    let locationManager = LocationManager.sharedLocationManager.locationManager
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println(launchOptions)
        
        if launchOptions?[UIApplicationLaunchOptionsLocationKey] != nil {
            println(launchOptions![UIApplicationLaunchOptionsLocationKey])
            // this means there is a location update
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
   
        }
            
        else
        {
            //this is when the app is launched normally
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        

        
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = StyleConstants.defaultColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 22)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UIToolbar.appearance().barTintColor = StyleConstants.defaultColor
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
        UIToolbar.appearance().translucent = false
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        println("entered background")
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
        HomeViewController().tableView.reloadData()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        println("app will terminate")
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        println("location was updated")
        
        //had to do this because it continuously updated the location when I went to the NewLocationViewController
        var aLocation = locations.last as! CLLocation
        sharedLocation.currentLocation = aLocation
        sharedLocation.currentLocationClosure?(aLocation, nil)
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        NSLog("Location manager failed with error: %@", error)
        if error.domain == kCLErrorDomain && CLError(rawValue: error.code) == CLError.Denied {
            //user denied location services so stop updating manager
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if region is CLCircularRegion {
            sharedLocation.handleRegionEntranceEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if region is CLCircularRegion {
            sharedLocation.handleRegionExitEvent(region)
        }
    }
    
}








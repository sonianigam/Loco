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
    
    var homeViewController: HomeViewController?
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println(launchOptions)
        
        if launchOptions?[UIApplicationLaunchOptionsLocationKey] != nil {
            println(launchOptions![UIApplicationLaunchOptionsLocationKey])
            // this means there is a location update
            homeViewController = HomeViewController()
            var locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "first if case"
            alert.addButtonWithTitle("Understood")
            alert.show()
        }
        
        else
        {
             //this is when the app is launched normally
            homeViewController = HomeViewController()
            var locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "second if case"
            alert.addButtonWithTitle("Understood")
            alert.show()

        }
        
        println("app was launched")
    
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = StyleConstants.defaultColor
        UINavigationBar.appearance().tintColor = UIColor.lightGrayColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 22)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        
        UIToolbar.appearance().barTintColor = StyleConstants.defaultColor
        UIToolbar.appearance().tintColor = UIColor.lightGrayColor()
        UIToolbar.appearance().translucent = false
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
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
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "third if case \(locations.last?.description)"
        alert.addButtonWithTitle("Understood")
        alert.show()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if region is CLCircularRegion {
            homeViewController!.handleRegionEntranceEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if region is CLCircularRegion {
            homeViewController!.handleRegionExitEvent(region)
        }
    }

}








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
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //this is when the app is launched normally
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        

        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = StyleConstants.defaultColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 22)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        UIToolbar.appearance().barTintColor = StyleConstants.defaultColor
        UIToolbar.appearance().tintColor = UIColor.white
        UIToolbar.appearance().isTranslucent = false
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        HomeViewController().tableView.reloadData()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
}








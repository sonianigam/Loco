//
//  LocationDisplayViewController.swift
//  FinalApp
//
//  Created by sonia on 8/7/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class LocationDisplayViewController: UIViewController {
    
    var homeViewController: HomeViewController?
    var keyLocation: KeyLocation?
    @IBOutlet weak var locationTimeLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationNotesTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var placeholderLabel = UILabel()
    var placeholderTVLabel = UILabel()
    var keyLocationVisits = List<Visit>()
    var dateFormatter = NSDateFormatter()
    var totalTime = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for visit in keyLocation!.visits
        {
            totalTime += visit.duration
        }
        
        locationTimeLabel.text = "total: \(printSecondsToHoursMinutesSeconds(totalTime))"
        locationNameLabel.text = keyLocation!.locationTitle
        locationNotesTextView.text = keyLocation!.notes
        keyLocationVisits = keyLocation!.visits
        tableView.separatorColor = StyleConstants.defaultColor
        tableView.dataSource = self
        
        
        if locationNotesTextView.text == ""
        {
            placeholderLabel = UILabel()
            placeholderLabel.text = "no saved notes about your location"
            placeholderLabel.sizeToFit()
            placeholderLabel.font = UIFont( name: "Helvetica Neue", size: 16)
            placeholderLabel.frame.origin = CGPointMake(5, locationNotesTextView.font.pointSize / 2)
            placeholderLabel.textColor = UIColor(white: 0, alpha: 0.22)

            var size = UIScreen.mainScreen().bounds.size.width/2.1
            println("\(size)")
            locationNotesTextView.addSubview(placeholderLabel)
            placeholderLabel.center = CGPointMake(size, 16)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (hr, min, 60 * secf)
    }
    
    func printSecondsToHoursMinutesSeconds (seconds:Double) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds)
        let string: String = "\(Int(round(h))) hr. \(Int(round(m))) min. \(Int(round(s))) sec."
        return string
    }
    
}

extension LocationDisplayViewController: UITableViewDataSource
    
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(keyLocation!.visits.count == 0){
            return 1
        }
        else {
            return keyLocation!.visits.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let realm = Realm()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! LocationDisplayCell
        if(keyLocation!.visits.count != 0){
            let row = indexPath.row
            let dailyData = keyLocationVisits[row]
            let today = NSDate()
            
                cell.configureCellWithDate(dailyData)
                cell.configureCellWithTime(dailyData)
                cell.configureCellWithTimeStamp(dailyData)


        
            placeholderTVLabel.text = ""
        }
        else {
            placeholderTVLabel.text = "no visits for this location yet!"
            placeholderTVLabel.sizeToFit()
            placeholderTVLabel.font = UIFont( name: "Helvetica Neue", size: 16)
            tableView.addSubview(placeholderTVLabel)
            placeholderTVLabel.frame.origin = CGPointMake(5, locationNotesTextView.font.pointSize / 2)
            placeholderTVLabel.textColor = UIColor(white: 0, alpha: 0.22)
            var size = UIScreen.mainScreen().bounds.size.width/1.96
            placeholderTVLabel.center = CGPointMake(size, 50)
            cell.dailyDate.text = ""
            cell.dailyDuration.text = ""
            cell.dailyEntryTime.text = ""
            
        }
        
        return cell
        
    }
    
    
}



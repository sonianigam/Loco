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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTimeLabel.text = "today: \(printSecondsToHoursMinutesSeconds(keyLocation!.time))"
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
            locationNotesTextView.addSubview(placeholderLabel)
            placeholderLabel.frame.origin = CGPointMake(5, locationNotesTextView.font.pointSize / 2)
            placeholderLabel.textColor = UIColor(white: 0, alpha: 0.22)
            placeholderLabel.textAlignment = NSTextAlignment.Center
            placeholderLabel.center = CGPointMake(170, 17)
            // placeholderLabel.center = locationNotesTextView.center
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
            
            if dailyData.date.timeIntervalSinceDate(today) < 604800
            {
                cell.configureCellWithDate(dailyData)
                cell.configureCellWithTime(dailyData)
                cell.configureCellWithTimeStamp(dailyData)
            }
            else
            {
                realm.write()
                    {
                        realm.delete(dailyData)
                }
            }
        
            placeholderTVLabel.text = ""
        }
        else {
            placeholderTVLabel.text = "here you will find a weekly view!"
            placeholderTVLabel.sizeToFit()
            placeholderTVLabel.font = UIFont( name: "Helvetica Neue", size: 16)
            tableView.addSubview(placeholderTVLabel)
            placeholderTVLabel.frame.origin = CGPointMake(5, locationNotesTextView.font.pointSize / 2)
            placeholderTVLabel.textColor = UIColor(white: 0, alpha: 0.22)
            placeholderTVLabel.textAlignment = NSTextAlignment.Center
            placeholderTVLabel.center = CGPointMake(180, 50)
            
            cell.dailyDate.text = ""
            cell.dailyDuration.text = ""
            
        }
        
        return cell
        
    }
    
    
}



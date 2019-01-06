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
    var dateFormatter = DateFormatter()
    var totalTime = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for visit in keyLocation!.visits
        {
            totalTime += visit.duration
        }
        
        locationTimeLabel.text = "total: \(printSecondsToHoursMinutesSeconds(seconds: totalTime))"
        locationNameLabel.text = keyLocation!.locationTitle
        locationNotesTextView.text = keyLocation!.notes
        tableView.separatorColor = StyleConstants.defaultColor
        tableView.dataSource = self
        
        if locationNotesTextView.text == ""
        {
            placeholderLabel = UILabel()
            placeholderLabel.text = "no saved notes about your location"
            placeholderLabel.sizeToFit()
            placeholderLabel.font = UIFont( name: "Helvetica Neue", size: 16)
            placeholderLabel.frame.origin = CGPoint.init(x: 5, y: locationNotesTextView.font!.pointSize / 2)
            placeholderLabel.textColor = UIColor(white: 0, alpha: 0.22)

            var size = UIScreen.main.bounds.size.width / 2.1
            locationNotesTextView.addSubview(placeholderLabel)
            placeholderLabel.center = CGPoint.init(x: size, y: 16)
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
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
        let string: String = "\(Int(round(h))) hr. \(Int(round(m))) min. \(Int(round(s))) sec."
        return string
    }
    
    
}

extension LocationDisplayViewController: UITableViewDataSource
    
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyLocation!.visits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationDisplayCell
        if(keyLocation!.visits.count != 0){
            
            let dailyData = keyLocation?.visits.sorted(byKeyPath: "date", ascending: false)[indexPath.row]
            
            cell.configureCellWithDate(dailyData: dailyData!)
            cell.configureCellWithTime(dailyData: dailyData!)
            cell.configureCellWithTimeStamp(dailyData: dailyData!)

            placeholderTVLabel.text = ""
        }
        else {
            placeholderTVLabel.text = "you haven't visited this location, yet!"
            placeholderTVLabel.sizeToFit()
            placeholderTVLabel.font = UIFont( name: "Helvetica Neue", size: 16)
            tableView.addSubview(placeholderTVLabel)
            placeholderTVLabel.frame.origin = CGPoint.init(x: 5, y: (locationNotesTextView.font?.pointSize)! / 2)
            placeholderTVLabel.textColor = UIColor(white: 0, alpha: 0.22)
            let size = UIScreen.main.bounds.size.width/1.93
            placeholderTVLabel.center = CGPoint.init(x: size, y: 50)
            cell.dailyDate.text = ""
            cell.dailyDuration.text = ""
            cell.dailyEntryTime.text = ""
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if (editingStyle == .delete) {
            let visit = keyLocation!.visits[indexPath.row]
            let realm = try! Realm()
            try! realm.write() {
                realm.delete(visit)
            }
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
            
        }
    }
    
    
}



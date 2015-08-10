//
//  LocationDisplayViewController.swift
//  FinalApp
//
//  Created by sonia on 8/7/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit

class LocationDisplayViewController: UIViewController {
    
    var homeViewController: HomeViewController?
    var keyLocation: KeyLocation?
    @IBOutlet weak var locationTimeLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationNotesTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var placeholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTimeLabel.text = "today: \(printSecondsToHoursMinutesSeconds(keyLocation!.time))"
        locationNameLabel.text = keyLocation!.locationTitle
        locationNotesTextView.text = keyLocation!.notes
        self.tableView.separatorColor = StyleConstants.defaultColor

        
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
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
}



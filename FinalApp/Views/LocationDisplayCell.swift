//
//  LocationDisplayCell.swift
//  FinalApp
//
//  Created by sonia on 8/8/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import Foundation
import UIKit

class LocationDisplayCell: UITableViewCell
{
    @IBOutlet weak var dailyDate: UILabel!
    @IBOutlet weak var dailyDuration: UILabel!
    @IBOutlet weak var dailyEntryTime: UILabel!
    
    var dateformatter = NSDateFormatter()
    var dateformatterTwo = NSDateFormatter()



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCellWithDate(dailyData: Visit) {
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        self.dailyDate.text = dateformatter.stringFromDate(dailyData.date)
        
    }
    
    func configureCellWithTimeStamp(dailyData: Visit)
    {
        dateformatterTwo.timeStyle = NSDateFormatterStyle.MediumStyle
        self.dailyEntryTime.text = dateformatterTwo.stringFromDate(dailyData.date)
    }
    
    func configureCellWithTime (dailyData: Visit)
    {
        self.dailyDuration.text = printSecondsToHoursMinutesSeconds(dailyData.duration)
        
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
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
    
    var dateformatter = DateFormatter()
    var dateformatterTwo = DateFormatter()



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithDate(dailyData: Visit) {
        dateformatter.dateStyle = DateFormatter.Style.medium
        self.dailyDate.text = dateformatter.string(from: dailyData.date as Date)
        
    }
    
    func configureCellWithTimeStamp(dailyData: Visit) {
        dateformatterTwo.timeStyle = DateFormatter.Style.medium
        self.dailyEntryTime.text = dateformatterTwo.string(from: dailyData.date as Date)
    }
    
    func configureCellWithTime (dailyData: Visit) {
        self.dailyDuration.text = printSecondsToHoursMinutesSeconds(seconds: dailyData.duration)
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

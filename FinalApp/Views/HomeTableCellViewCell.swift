//
//  HomeTableCellTableViewCell.swift
//  FinalApp
//
//  Created by sonia on 7/30/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class HomeTableCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    var totalDailyDuration = Double()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func configureCellWithKeyLocation(aKeyLocation: KeyLocation) {
        self.locationTitle.text = aKeyLocation.locationTitle
        
    }
    
    func configureCellWithTime (aKeyLocation: KeyLocation)
    {
        let realm = Realm()
        totalDailyDuration = 0
        
        for aVisit in aKeyLocation.visits
        {
            if aVisit.date.timeIntervalSinceNow > -86400
            {
                totalDailyDuration += aVisit.duration
            }
        }
    
        realm.write()
            {
                aKeyLocation.time = self.totalDailyDuration
        }
    
        self.timeStamp.text = printSecondsToHoursMinutesSeconds(totalDailyDuration)

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

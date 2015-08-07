//
//  Location.swift
//  FinalApp
//
//  Created by sonia on 7/27/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import RealmSwift
import CoreLocation

class KeyLocation: Object {
    
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var address: String = ""
    dynamic var notes: String = ""
    dynamic var locationTitle : String = ""
    dynamic var time: Double = 0
    dynamic var visits = [Visit]()

}

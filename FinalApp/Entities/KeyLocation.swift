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
    var latitude: Double = 0
    var longitude: Double = 0
    var address: String = ""
    var notes: String = ""
    var locationTitle : String = ""
    var time: Double = 0
    var visits = List<Visit>()
    var inside: Bool = false
}

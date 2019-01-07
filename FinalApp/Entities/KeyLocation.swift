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
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var address: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var locationTitle : String = ""
    @objc dynamic var time: Double = 0
    var visits = List<Visit>()
    @objc dynamic var inside: Bool = false
}

//
//  Visit.swift
//  FinalApp
//
//  Created by sonia on 8/7/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import Foundation
import RealmSwift

class Visit: Object {
    dynamic var date = NSDate()
    dynamic var duration: Double = 0.0
    dynamic var note = String()
}
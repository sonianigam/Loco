//
//  StyleConstants.swift
//  FinalApp
//
//  Created by sonia on 8/1/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import Foundation

import UIKit

struct StyleConstants {
    
    static let defaultColor = UIColor(rgb: 0x981ADE)

    
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
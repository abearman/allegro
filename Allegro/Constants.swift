//
//  Constants.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import Foundation
import UIKit

let NUM_STAFF_LINES: Int = 7
let BLUE_COLOR = UIColor(red:0.68, green:0.92, blue:1.0, alpha:1.0)

func setViewBorder(_ view: UIView, color: UIColor, width: Int) {
  view.layer.borderColor = color.cgColor
  view.layer.borderWidth = CGFloat(width)
}

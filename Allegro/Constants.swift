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
let MEASURE_LINE_WIDTH = CGFloat(3.0)
let BLUE_COLOR = UIColor(red:0.68, green:0.92, blue:1.0, alpha:1.0)
let RIGHT_MENU_WIDTH = CGFloat(180.0)

let SHARP_KEYS = ["C Major", "G Major", "D Major",
                  "A Major", "E Major", "B Major",
                  "F# Major", "C# Major"]

let FLAT_KEYS = ["C Major", "F Major", "B♭ Major",
                 "E♭ Major", "A♭ Major", "D♭ Major",
                 "G♭ Major", "C♭ Major"]

let COMPOSE_MODE_NOTIFICATION = "Compose Mode Changed"

func setViewBorder(_ view: UIView, color: UIColor, width: Int) {
  view.layer.borderColor = color.cgColor
  view.layer.borderWidth = CGFloat(width)
}

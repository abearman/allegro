//
//  Constants.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import Foundation
import UIKit


let BLUE_COLOR = UIColor(red:0.68, green:0.92, blue:1.0, alpha:1.0)

func setViewBorder(view: UIView, color: UIColor, width: Int) {
  view.layer.borderColor = color.CGColor
  view.layer.borderWidth = CGFloat(width)
}
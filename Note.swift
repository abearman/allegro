//
//  Note.swift
//  Allegro
//
//  Created by Amy Bearman on 11/20/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class Note {

  var shapeLayer: CAShapeLayer = CAShapeLayer()
  var isSelected: Bool = false
  var isFilled: Bool = true
  
  init(shapeLayer: CAShapeLayer, isFilled: Bool) {
    self.shapeLayer = shapeLayer
    self.isFilled = isFilled
  }
  
}
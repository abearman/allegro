//
//  Note.swift
//  Allegro
//
//  Created by Amy Bearman on 11/20/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit


/* Right now this only supports one-part compositions */
class Composition {
  var measures: [Measure] = [Measure]()
}

class Measure {
  var notes: [Note] = [Note]()
  
  var keySignature: KeySignature = KeySignature()
  var timeSignature: TimeSignature = TimeSignature()
}


class KeySignature {
  var numSharps: Int = 0
  var numFlats: Int = 0
}


class TimeSignature {
  var totalDivisions: Float = 0.0
  var divisionsPerQuarterNote: Float = 0.0
}


enum NoteType {
  case Whole
  case Half
  case Quarter
  case Eighth
  case Sixteenth
  case Thirtysecond
  case Sixtyfourth
}


class Note {
  
  /* LOGIC STUFF */
  var noteType: NoteType = NoteType.Quarter
  
  /* Number of divisions taken up by this note (e.g., 8th note in 3/4 time = 1/2 division */
  var duration: Float = 0.0
  
  var numDots: Int = 0
  
  /* UI STUFF */
  var shapeLayer: CAShapeLayer = CAShapeLayer()
  var accidentalImageView: UIImageView? = nil
  
  var isSelected: Bool = false
  var isFilled: Bool = true
  var location: CGPoint = CGPoint(x:0, y:0)
  
  init(_ shapeLayer: CAShapeLayer, _ isFilled: Bool) {
    self.shapeLayer = shapeLayer
    self.isFilled = isFilled
  }
  
}

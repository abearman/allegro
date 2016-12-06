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
  var measures: [Measure] = [Measure()]  // Default: one measure
}

class Measure {
  var notes: [Note] = [Note]()
  
  var keySignature: KeySignature = KeySignature()
  var timeSignature: TimeSignature = TimeSignature()
}


class KeySignature {
  var numSharps: Int = 0  // Default: C Major
  var numFlats: Int = 0
  
  init(_ numSharps: Int, _ numFlats: Int) {
    self.numSharps = numSharps
    self.numFlats = numFlats
  }
  
  init() {}
}


class TimeSignature {
  // Default: 4/4
  var totalDivisions: Int = 4   // Top number
  var durationPerDivision: Int = 4 {  // Bottom number
    didSet {
      divisionsPerQuarterNote = Float(durationPerDivision) / 4.0
    }
  }
  var divisionsPerQuarterNote: Float = 0.0
  
  init(_ top: Int, _ bottom: Int) {
    self.totalDivisions = top
    self.durationPerDivision = bottom
  }
  
  init() {}
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

enum Accidental {
  case Sharp
  case Flat
  case DoubleSharp
  case DoubleFlat
  case Natural
  case None
}

class Note {
  var noteType: NoteType = NoteType.Quarter
  
  /* Number of divisions taken up by this note (e.g., 8th note in 3/4 time = 1/2 division */
  var duration: Float = 0.0
  var accidental: Accidental = Accidental.None
  var numDots: Int = 0
  
  var noteLayer: NoteLayer = NoteLayer()
}

  
class NoteLayer {
  var shapeLayer: CAShapeLayer = CAShapeLayer()
  var accidentalImageView: UIImageView? = nil
  
  var isSelected: Bool = false
  var isFilled: Bool = true
  var location: CGPoint = CGPoint(x:0, y:0)
  
  init(_ shapeLayer: CAShapeLayer, _ isFilled: Bool) {
    self.shapeLayer = shapeLayer
    self.isFilled = isFilled
  }
  
  init() {}
}

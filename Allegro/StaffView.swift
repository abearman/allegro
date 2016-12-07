//
//  StaffView.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffView: UIView {
  
  /* Model: single Measure per StaffView */
  var measure: Measure = Measure() {
    didSet {
      /* If we updated time signature */
      if (oldValue.timeSignature.totalDivisions !=
        measure.timeSignature.totalDivisions) {
        setXPositions()
      }
    }
  }
  
  var noteDuration: Int = 0
  
  var sharpYOffset: CGFloat = 0.0
  var sharpSize: CGSize = CGSize(width: 0, height: 0) {
    didSet {
      sharpYOffset = sharpSize.height / 6
    }
  }
  var flatYOffset: CGFloat = 0.0
  var flatSize: CGSize = CGSize(width: 0, height: 0) {
    didSet {
      flatYOffset = flatSize.height / 3
    }
  }
  var naturalYOffset: CGFloat = 0.0
  var naturalSize: CGSize = CGSize(width: 0, height: 0) {
    didSet {
      naturalYOffset = naturalSize.height / 6
    }
  }
  
  var noteSep: CGFloat = 0.0
  var noteSize: CGSize = CGSize(width: 0, height: 0) {
    didSet {
      noteSep = noteSize.width
      noteSize.width = 1.3 * noteSize.height
      
      flatSize.width = noteSize.width / 2
      sharpSize.width = noteSize.width / 3
      naturalSize.width = noteSize.width / 3
    }
  }
  
  var startGesture: CGPoint = CGPoint(x: 0, y: 0)
  
  
  // pragma MARK - Barlines and horizontal positions
  
  /* List of y-value positions of the bar lines on the screen, from high to low */
  var barlines = [CGFloat]() {
    didSet {
      /* Set note width and height */
      if barlines.count > 1 {
        noteSize.height = barlines[1] - barlines[0]
      }
    }
  }
  var xPositions = [CGFloat]()
  
  override func draw(_ rect: CGRect) {
    drawBarLines()
    setXPositions()
  }
  
  
  func drawBarLines() {
    for i in 1...NUM_STAFF_LINES {
      let path = UIBezierPath()
      let yVal = CGFloat(i) * self.frame.height / CGFloat(NUM_STAFF_LINES + 1)
      barlines.append(yVal)
      path.move(to: CGPoint(x:0, y:yVal))
      path.addLine(to: CGPoint(x:self.frame.width, y:yVal))
      path.close()
      UIColor.black.set()
      
      /* Dotted line for upper and lower bar lines */
      if ((i == 1) || (i == NUM_STAFF_LINES)) {
        let dashes: [ CGFloat ] = [4.0, 8.0]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        UIColor.lightGray.set()
      }
      path.stroke()
    }
    
    /* Draw measure line */
    let measurePath = UIBezierPath()
    measurePath.move(to: CGPoint(x: self.frame.width,
                                 y: 0.0))
    measurePath.addLine(to: CGPoint(x: self.frame.width,
                                    y: self.frame.height))
    UIColor.black.set()
    measurePath.lineWidth = MEASURE_LINE_WIDTH
    measurePath.stroke()
  }
  
  
  func setXPositions() {
    /* Top time sig is 2, 4, or 8 */
    var numNotes = 4
    
    /* Top time sig is 3 or 6 */
    let topTimeSig = measure.timeSignature.totalDivisions
    if (topTimeSig == 3 || topTimeSig == 6) {
      numNotes = 6
    }
    
    /* Clear any existing xPositions */
    xPositions.removeAll()
    
    var lastXVal = CGFloat(0)
    for i in 1...numNotes {
      let xVal = CGFloat(i) * self.frame.width / CGFloat(numNotes)
      let noteXVal = lastXVal + ((xVal - lastXVal) / 2) - CGFloat(noteSize.width/2)
      xPositions.append(noteXVal)
      lastXVal = xVal
      
      /*let aPath = UIBezierPath()
       aPath.moveToPoint(CGPoint(x:xVal, y:0))
       aPath.addLineToPoint(CGPoint(x:xVal, y:self.frame.height))
       aPath.closePath()
       UIColor.blackColor().set()
       aPath.stroke()*/
    }
    setNeedsDisplay()
  }
  
  
  // MARK - Gesture Recognizers

  /*func handlePan(_ gesture: UIPanGestureRecognizer) {
     let location = gesture.location(in: self)
     
     switch gesture.state {
     case .changed, .ended:
       for note in existingNotes {
        if (note.shapeLayer.path?.contains(location))! {
          selectNote(note)
          moveNote(note: note, panLocation: location, snap: false)
        }
       }
     case .ended:
      for note in existingNotes {
        if (note.shapeLayer.path?.contains(location))! {
          selectNote(note)
          moveNote(note: note, panLocation: location, snap: true)
        }
      }
     default:
      break
     }
   }*/
  
  
  func handleErasePan(_ gesture: UIPanGestureRecognizer) {
    let location = gesture.location(in: self)
    
    switch gesture.state {
    case .changed, .ended:
      for note in measure.notes {
        let noteLayer = note.noteLayer
        if (noteLayer.shapeLayer.path?.contains(location))! {
          eraseNote(note)
        }
      }
    default:
      break
    }
  }
  
  
  func gestureAddOrSelectNote(location: CGPoint) {
    /* Check to see if we tapped an existing Note.
     * If so, select/de-select it. */
    if let existingNote = didTapExistingNote(location) {
      let noteLayer = existingNote.noteLayer
      if noteLayer.isSelected {
        print("Deselecting note")
        deselectNote(noteLayer)
      } else {
        print("Selecting note")
        selectNote(noteLayer)
      }
      
      /* Otherwise, add a new Note. */
    } else {
      print("Adding new note")
      addNote(location)
    }
  }
  
  
  func gestureAddFlat() {
    print("Adding flat")
    if let existingNote = didTapExistingNote(startGesture) {
      /* Update UI */
      let noteLayer = existingNote.noteLayer
      let flatImage = UIImage(named: "flat")
      let ratio = flatSize.width / (flatImage?.size.width)!
      flatSize.height = ratio * (flatImage?.size.height)!
      
      let flatImageView = UIImageView(image: flatImage)
      flatImageView.frame = CGRect(x: noteLayer.location.x - flatSize.width,
                                   y: noteLayer.location.y - flatYOffset,
                                   width: flatSize.width,
                                   height: flatSize.height)
      if (noteLayer.accidentalImageView != nil) {
        noteLayer.accidentalImageView?.removeFromSuperview()
      }
      
      noteLayer.accidentalImageView = flatImageView
      self.addSubview(flatImageView)
      
      /* Update model */
      if (existingNote.accidental == Accidental.Flat) {
        existingNote.accidental = Accidental.DoubleFlat
      } else {
        existingNote.accidental = Accidental.Flat
      }
    }
  }
  
  
  func gestureAddSharp() {
    print("Adding sharp")
    if let existingNote = didTapExistingNote(startGesture) {
      /* Update UI */
      let noteLayer = existingNote.noteLayer
      let sharpImage = UIImage(named: "sharp")
      let ratio = sharpSize.width / (sharpImage?.size.width)!
      sharpSize.height = ratio * (sharpImage?.size.height)!
      
      let sharpImageView = UIImageView(image: sharpImage)
      sharpImageView.frame = CGRect(x: noteLayer.location.x - sharpSize.width,
                                    y: noteLayer.location.y - sharpYOffset,
                                    width: sharpSize.width,
                                    height: sharpSize.height)
      if (noteLayer.accidentalImageView != nil) {
        noteLayer.accidentalImageView?.removeFromSuperview()
      }
      
      noteLayer.accidentalImageView = sharpImageView
      self.addSubview(sharpImageView)
      
      /* Update model */
      if (existingNote.accidental == Accidental.Flat) {
        existingNote.accidental = Accidental.DoubleFlat
      } else {
        existingNote.accidental = Accidental.Flat
      }
    }
  }
  
  
  func gestureAddNatural() {
    print("Detected natural gesture")
    if let existingNote = didTapExistingNote(startGesture) {
      /* Update UI */
      let noteLayer = existingNote.noteLayer
      let naturalImage = UIImage(named: "natural")
      let ratio = naturalSize.width / (naturalImage?.size.width)!
      naturalSize.height = ratio * (naturalImage?.size.height)!
      
      let naturalImageView = UIImageView(image: naturalImage)
      naturalImageView.frame = CGRect(x: noteLayer.location.x - naturalSize.width,
                                      y: noteLayer.location.y - naturalYOffset,
                                      width: naturalSize.width,
                                      height: naturalSize.height)
      if (noteLayer.accidentalImageView != nil) {
        noteLayer.accidentalImageView?.removeFromSuperview()
      }
      
      noteLayer.accidentalImageView = naturalImageView
      self.addSubview(naturalImageView)
      
      /* Update model */
      existingNote.accidental = Accidental.Natural
    }
  }
  
  
  func gestureMeasureForwardSwipe() {
    print("Measure swipe forward")
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: MEASURE_SWIPE_FORWARD_NOTIFICATION)))
  }
  
  func gestureMeasureReverseSwipe() {
    print("Measure swipe reverse")
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: MEASURE_SWIPE_REVERSE_NOTIFICATION)))
  }
  
  
  func didTapExistingNote(_ location: CGPoint) -> Note? {
    for note in measure.notes {
      let noteLayer = note.noteLayer
      if (noteLayer.shapeLayer.path?.contains(location))! {
        return note
      }
    }
    return nil
  }
  
  
  // MARK - Manipulate Notes
  
  func selectNote(_ selectedNoteLayer: NoteLayer) {
    /* De-select all notes */
    for note in measure.notes {
      deselectNote(note.noteLayer)
    }
    
    selectedNoteLayer.isSelected = true
    
    selectedNoteLayer.shapeLayer.fillColor = BLUE_COLOR.cgColor
    selectedNoteLayer.shapeLayer.lineWidth = 2
    if (selectedNoteLayer.isFilled) {
      selectedNoteLayer.shapeLayer.strokeColor = BLUE_COLOR.cgColor
    } else {
      selectedNoteLayer.shapeLayer.strokeColor = UIColor.black.cgColor
    }
    setNeedsDisplay()
  }
  
  
  func deselectNote(_ selectedNoteLayer: NoteLayer) {
    selectedNoteLayer.isSelected = false
    
    selectedNoteLayer.shapeLayer.strokeColor = UIColor.black.cgColor
    if (selectedNoteLayer.isFilled) {
      selectedNoteLayer.shapeLayer.fillColor = UIColor.black.cgColor
    } else {
      selectedNoteLayer.shapeLayer.fillColor = UIColor.clear.cgColor
    }
    setNeedsDisplay()
  }
  
  
  func addNote(_ tapLocation: CGPoint) {
    /* Update UI */
    let isFilled = shouldFillInNote()
    
    let noteX = getNoteXPos(tapLocation.x)
    let noteY = getNoteBarline(tapLocation.y)
    
    let notePath = UIBezierPath(ovalIn:
      CGRect(x: noteX, y: noteY, width: noteSize.width, height: noteSize.height))
    addNoteStem(notePath: notePath, noteX: noteX, noteY: noteY)
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = notePath.cgPath
    
    /* Update model: add Note to Measure */
    let newNote = Note()
    newNote.type = NoteType(rawValue: self.noteDuration)!
    // TODO: add Note duration
    newNote.noteLayer = NoteLayer(shapeLayer, isFilled)
    newNote.noteLayer.location = CGPoint(x:noteX, y:noteY)
    measure.notes.append(newNote)
    
    /* Add NoteLayer to superview */
    selectNote(newNote.noteLayer)
    self.layer.addSublayer(shapeLayer)
  }
  
  
  func addNoteStem(notePath: UIBezierPath, noteX: CGFloat, noteY: CGFloat) {
    if (noteDuration > 0) {
      /* Stem going up and on right side if note is on bottom half of staff */
      var xEndPoint = noteX + noteSize.width
      var yEndPoint = noteY - 2 * noteSize.height
      
      /* Stem going down and on left side if note is on upper half of staff */
      if (noteY < self.frame.height/2) {
        notePath.move(to: CGPoint(x: noteX, y: noteY + noteSize.width/3))
        xEndPoint = noteX
        yEndPoint = noteY + 3 * noteSize.height
      }
      notePath.addLine(to: CGPoint(x: xEndPoint,
                                   y: yEndPoint))
    }
  }
  
  
  func eraseNote(_ note: Note) {
    /* Update UI */
    let noteLayer = note.noteLayer
    noteLayer.shapeLayer.removeFromSuperlayer()
    noteLayer.accidentalImageView?.layer.removeFromSuperlayer()
    
    /* Update model */
    if let index = measure.notes.index(where: {$0 === note}) {
      measure.notes.remove(at: index)
    }
  }
  
  
  func moveNote(note: Note, panLocation: CGPoint, snap: Bool) {
    var noteX = panLocation.x - CGFloat(noteSize.width / 2)
    var noteY = panLocation.y - CGFloat(noteSize.height / 2)
    if (snap) {
      noteX = getNoteXPos(panLocation.x)
      noteY = getNoteBarline(panLocation.y)
    }
    
    let notePath = UIBezierPath(ovalIn: CGRect(x: noteX, y: noteY, width: noteSize.width, height: noteSize.height))
    note.noteLayer.shapeLayer.path = notePath.cgPath
    note.noteLayer.location = CGPoint(x: noteX, y: noteY)
    setNeedsDisplay()
  }
  
  
  func getNoteXPos(_ tapX: CGFloat) -> CGFloat {
    var smallestXDiff = self.frame.width
    var bestXPos = xPositions[0]
    
    for xPos in xPositions {
      let xDiff = abs(xPos - tapX)
      if (xDiff < smallestXDiff) {
        smallestXDiff = xDiff
        bestXPos = xPos
      }
    }
    
    return bestXPos
  }
  
  
  func getNoteBarline(_ tapY: CGFloat) -> CGFloat {
    let barWidth = barlines[1] - barlines[0]
    var largeBar = barlines[barlines.count-1]  // Larger y-coord
    var smallBar = barlines[0]   // Smaller y-coord
    
    for barlineY in barlines {
      if ( (tapY > barlineY) && (barlineY > smallBar) ) {
        smallBar = barlineY
      }
      if ( (tapY < barlineY) && (barlineY < largeBar) ) {
        largeBar = barlineY
      }
      
      if ( abs(tapY - barlineY) < (barWidth/4) ) {
        return barlineY - CGFloat(noteSize.height / 2)
      }
    }
    let noteY = smallBar + (largeBar-smallBar)/2 - CGFloat(noteSize.height / 2)
    return noteY
  }
  
  
  func shouldFillInNote() -> Bool {
    return noteDuration > 1
  }
  
  
}

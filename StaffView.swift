//
//  StaffView.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffView: UIView {
  
  var noteDuration: Int = 0
  
  var noteWidth: CGFloat = 0.0
  var noteHeight: CGFloat = 0.0 {
    didSet {
      noteWidth = 1.4 * noteHeight
    }
  }
  
  var existingNotes: [Note] = []
  
  /* List of y-value positions of the bar lines on the screen, from high to low */
  var barlines = [CGFloat]() {
    didSet {
      /* Set note width and height */
      if barlines.count > 1 {
        noteHeight = barlines[1] - barlines[0]
      }
    }
  }
  
  
  override func drawRect(rect: CGRect) {
    drawBarLines()
  }
  
  
  func drawBarLines() {
    for i in 1...NUM_STAFF_LINES {
      let aPath = UIBezierPath()
      let yVal = CGFloat(i) * self.frame.height / CGFloat(NUM_STAFF_LINES + 1)
      barlines.append(yVal)
      aPath.moveToPoint(CGPoint(x:0, y:yVal))
      aPath.addLineToPoint(CGPoint(x:self.frame.width, y:yVal))
      aPath.closePath()
      
      UIColor.blackColor().set()
      aPath.stroke()
    }
  }
  
  
  func tappedView(gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .Ended:
      let location = gesture.locationInView(self)
      
      /* Check to see if we tapped an existing note. If so, select it */
      var foundExistingNote = false
      for note in existingNotes {
        if (CGPathContainsPoint(note.shapeLayer.path, nil, location, false)) {
          foundExistingNote = true
          selectNote(note.shapeLayer)
        }
      }
      
      if (!foundExistingNote) {
        var noteLayer = addNote(location, filledNote: shouldFillInNote())
        selectNote(noteLayer)
      }
  
    default:
      break
    }
  }
  
  
  func selectNote(selectedNoteLayer: CAShapeLayer) {
    /* De-select all notes */
    for note in existingNotes {
      note.shapeLayer.fillColor = UIColor.blackColor().CGColor
    }
    
    selectedNoteLayer.fillColor = BLUE_COLOR.CGColor
    setNeedsDisplay()
  }
  
  
  func addNote(tapLocation: CGPoint, filledNote: Bool) -> CAShapeLayer {
    let noteX = tapLocation.x - CGFloat(noteWidth/2)
    //let noteY = tapLocation.y
    let noteY = getNoteBarline(tapLocation.y)
    let notePath = UIBezierPath(ovalInRect: CGRectMake(noteX, noteY, noteWidth, noteHeight))
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = notePath.CGPath
    
    shapeLayer.strokeColor = UIColor.blackColor().CGColor
    if (filledNote) {
      shapeLayer.fillColor = UIColor.blackColor().CGColor
    } else {
      shapeLayer.fillColor = UIColor.clearColor().CGColor
      shapeLayer.lineWidth = 4
    }
    
    /* Add Note to array */
    let newNote = Note(shapeLayer: shapeLayer)
    existingNotes.append(newNote)
    
    /* Add note layer to superview */
    self.layer.addSublayer(shapeLayer)
    return shapeLayer
  }
  
  
  func getNoteBarline(tapY: CGFloat) -> CGFloat {
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
        return barlineY - CGFloat(noteHeight/2)
      }
    }
    let noteY = smallBar + (largeBar-smallBar)/2 - CGFloat(noteHeight/2)
    return noteY
  }
  
  
  func shouldFillInNote() -> Bool {
    return noteDuration > 1
  }
  

}

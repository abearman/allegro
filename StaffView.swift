//
//  StaffView.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffView: UIView {
  
  var topTimeSig: Int = 4 {
    didSet {
      setXPositions()
    }
  }
  
  var noteDuration: Int = 0
  
  var noteSep: CGFloat = 0.0
  var noteWidth: CGFloat = 0.0 {
    didSet {
      noteSep = noteWidth
    }
  }
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
  var xPositions = [CGFloat]()
  
  override func draw(_ rect: CGRect) {
    drawBarLines()
    setXPositions()
  }
  
  
  func drawBarLines() {
    for i in 1...NUM_STAFF_LINES {
      let aPath = UIBezierPath()
      let yVal = CGFloat(i) * self.frame.height / CGFloat(NUM_STAFF_LINES + 1)
      barlines.append(yVal)
      aPath.move(to: CGPoint(x:0, y:yVal))
      aPath.addLine(to: CGPoint(x:self.frame.width, y:yVal))
      aPath.close()
      
      UIColor.black.set()
      aPath.stroke()
    }
  }
  
  
  func setXPositions() {
    /* Top time sig is 2, 4, or 8 */
    var numNotes = 4
    
    /* Top time sig is 3 or 6 */
    if (topTimeSig == 3 || topTimeSig == 6) {
      numNotes = 6
    }
    
    /* Clear any existing xPositions */
    xPositions.removeAll()
    
    var lastXVal = CGFloat(0)
    for i in 1...numNotes {
      let xVal = CGFloat(i) * self.frame.width / CGFloat(numNotes)
      let noteXVal = lastXVal + ((xVal - lastXVal) / 2) - CGFloat(noteWidth/2)
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
  
  
  func tappedView(_ gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .ended:
      let location = gesture.location(in: self)
      
      /* Check to see if we tapped an existing Note.
       * If so, select/de-select it. */
      var foundExistingNote = false
      for note in existingNotes {
        if (note.shapeLayer.path?.contains(location))! {
          foundExistingNote = true
          if (note.isSelected) {
            deselectNote(note)
          } else {
            selectNote(note)
          }
        }
      }
      
      /* Otherwise, add a new Note. */
      if (!foundExistingNote) {
        addNote(location, isFilled: shouldFillInNote())
      }
  
    default:
      break
    }
  }
  
  
  func selectNote(_ selectedNote: Note) {
    /* De-select all notes */
    for note in existingNotes {
      deselectNote(note)
    }
    
    selectedNote.isSelected = true
    
    selectedNote.shapeLayer.fillColor = BLUE_COLOR.cgColor
    selectedNote.shapeLayer.strokeColor = UIColor.black.cgColor
    if (selectedNote.isFilled) {
      selectedNote.shapeLayer.lineWidth = 0
    } else {
      selectedNote.shapeLayer.lineWidth = 4
    }
    
    setNeedsDisplay()
  }
  
  
  func deselectNote(_ selectedNote: Note) {
    selectedNote.isSelected = false
    
    if (selectedNote.isFilled) {
      selectedNote.shapeLayer.fillColor = UIColor.black.cgColor
    } else {
      selectedNote.shapeLayer.fillColor = UIColor.clear.cgColor
    }
    
    setNeedsDisplay()
  }
  
  
  func addNote(_ tapLocation: CGPoint, isFilled: Bool) {
    //let noteX = tapLocation.x - CGFloat(noteWidth/2)
    let noteX = getNoteXPos(tapLocation.x)
    let noteY = getNoteBarline(tapLocation.y)
    let notePath = UIBezierPath(ovalIn: CGRect(x: noteX, y: noteY, width: noteWidth, height: noteHeight))
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = notePath.cgPath
    
    /* Add Note to array */
    let newNote = Note(shapeLayer: shapeLayer, isFilled: isFilled)
    existingNotes.append(newNote)
    
    /* Add note layer to superview */
    selectNote(newNote)
    self.layer.addSublayer(shapeLayer)
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

//
//  StaffView.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffView: UIView {
  
  var noteGR: NoteGestureRecognizer!
  var eraseGR: UIPanGestureRecognizer!
  
  var composeMode: ComposeMode = ComposeMode.Note {
    didSet {
      switch composeMode {
      case .Note:
        if eraseGR != nil {
          self.removeGestureRecognizer(eraseGR)
        }
        
        self.noteGR = NoteGestureRecognizer(target: self, action: #selector(handleNoteGesture(_:)))
        self.addGestureRecognizer(noteGR)
        
      case .Erase:
        if noteGR != nil {
          self.removeGestureRecognizer(noteGR)
        }
        
        self.eraseGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(eraseGR)
          
      default:
        break
      }
      
    }
  }
  
  var topTimeSig: Int = 4 {
    didSet {
      setXPositions()
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
  
  var existingNotes: [Note] = []
  
  var startGesture: CGPoint = CGPoint(x: 0, y: 0)
  
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
  
  func handlePan(_ gesture: UIPanGestureRecognizer) {
    let location = gesture.location(in: self)
    
    switch gesture.state {
    case .changed, .ended:
      for note in existingNotes {
        if (note.shapeLayer.path?.contains(location))! {
          eraseNote(note: note)
        }
      }
    default:
      break
    }
  }
  
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
  
  
  func handleNoteGesture(_ gesture: NoteGestureRecognizer) {
    let location = gesture.location(in: self)
    
    if(gesture.state == .began) {
      startGesture = location
    
    } else if (gesture.state == .ended) {
    
      /* Add (or select/de-select) a note */
      if ((gesture.noteState == NoteGestureRecognizer.NoteGestureRecognizerState.newNote)) {
        
        /* Check to see if we tapped an existing Note.
         * If so, select/de-select it. */
        let existingNote = didTapExistingNote(location: location)
        if let note = existingNote {
          if note.isSelected {
            deselectNote(note)
          } else {
            selectNote(note)
          }
          
        /* Otherwise, add a new Note. */
        } else {
          print("Adding new note")
          addNote(location, isFilled: shouldFillInNote())
        }
        
      /* Add a flat accidental */
      } else if (gesture.noteState == NoteGestureRecognizer.NoteGestureRecognizerState.flat) {
        let existingNote = didTapExistingNote(location: startGesture)
        if let note = existingNote {
          let flatImage = UIImage(named: "flat")
          let ratio = flatSize.width / (flatImage?.size.width)!
          flatSize.height = ratio * (flatImage?.size.height)!
          
          let flatImageView = UIImageView(image: flatImage)
          flatImageView.frame = CGRect(x: note.location.x - flatSize.width,
                                       y: note.location.y - flatYOffset,
                                       width: flatSize.width,
                                       height: flatSize.height)
          if (note.accidentalImageView != nil) {
            note.accidentalImageView?.removeFromSuperview()
          }
          
          note.accidentalImageView = flatImageView
          self.addSubview(flatImageView)
        }
      
      /* Add a sharp accidental */
      } else if (gesture.noteState == NoteGestureRecognizer.NoteGestureRecognizerState.sharp) {
        let existingNote = didTapExistingNote(location: startGesture)
        if let note = existingNote {
          let sharpImage = UIImage(named: "sharp")
          let ratio = sharpSize.width / (sharpImage?.size.width)!
          sharpSize.height = ratio * (sharpImage?.size.height)!
          
          let sharpImageView = UIImageView(image: sharpImage)
          sharpImageView.frame = CGRect(x: note.location.x - sharpSize.width,
                                        y: note.location.y - sharpYOffset,
                                        width: sharpSize.width,
                                        height: sharpSize.height)
          if (note.accidentalImageView != nil) {
            note.accidentalImageView?.removeFromSuperview()
          }
          
          note.accidentalImageView = sharpImageView
          self.addSubview(sharpImageView)
        }
      
      /* Add a natural accidental */
      } else if (gesture.noteState == NoteGestureRecognizer.NoteGestureRecognizerState.natural) {
        print("Natural gesture")
        let existingNote = didTapExistingNote(location: startGesture)
        if let note = existingNote {
          let naturalImage = UIImage(named: "natural")
          let ratio = naturalSize.width / (naturalImage?.size.width)!
          naturalSize.height = ratio * (naturalImage?.size.height)!
          
          let naturalImageView = UIImageView(image: naturalImage)
          naturalImageView.frame = CGRect(x: note.location.x - naturalSize.width,
                                          y: note.location.y - naturalYOffset,
                                          width: naturalSize.width,
                                          height: naturalSize.height)
          if (note.accidentalImageView != nil) {
            note.accidentalImageView?.removeFromSuperview()
          }
          
          note.accidentalImageView = naturalImageView
          self.addSubview(naturalImageView)
        }
        
      }
    }
  
  }


  func didTapExistingNote(location: CGPoint) -> Note? {
    for note in existingNotes {
      if (note.shapeLayer.path?.contains(location))! {
        return note
      }
    }
    return nil
  }
  
  
  // MARK - Manipulate Notes
  
  func selectNote(_ selectedNote: Note) {
    /* De-select all notes */
    for note in existingNotes {
      deselectNote(note)
    }
    
    selectedNote.isSelected = true
    
    selectedNote.shapeLayer.fillColor = BLUE_COLOR.cgColor
    selectedNote.shapeLayer.lineWidth = 2
    if (selectedNote.isFilled) {
      selectedNote.shapeLayer.strokeColor = BLUE_COLOR.cgColor
    } else {
      selectedNote.shapeLayer.strokeColor = UIColor.black.cgColor
    }
    setNeedsDisplay()
  }
  
  
  func deselectNote(_ selectedNote: Note) {
    selectedNote.isSelected = false
    
    selectedNote.shapeLayer.strokeColor = UIColor.black.cgColor
    if (selectedNote.isFilled) {
      selectedNote.shapeLayer.fillColor = UIColor.black.cgColor
    } else {
      selectedNote.shapeLayer.fillColor = UIColor.clear.cgColor
    }
    setNeedsDisplay()
  }
  
  
  func addNote(_ tapLocation: CGPoint, isFilled: Bool) {
    let noteX = getNoteXPos(tapLocation.x)
    let noteY = getNoteBarline(tapLocation.y)
    
    let notePath = UIBezierPath(ovalIn:
      CGRect(x: noteX, y: noteY, width: noteSize.width, height: noteSize.height))
    addNoteStem(notePath: notePath, noteX: noteX, noteY: noteY)
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = notePath.cgPath
    
    /* Add Note to array */
    let newNote = Note(shapeLayer: shapeLayer, isFilled: isFilled)
    newNote.location = CGPoint(x:noteX, y:noteY)
    existingNotes.append(newNote)
    
    /* Add note layer to superview */
    selectNote(newNote)
    
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
  
  
  func eraseNote(note: Note) {
    note.shapeLayer.removeFromSuperlayer()
    note.accidentalImageView?.layer.removeFromSuperlayer()
    if let index = existingNotes.index(where: {$0 === note}) {
      existingNotes.remove(at: index)
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
    note.shapeLayer.path = notePath.cgPath
    note.location = CGPoint(x: noteX, y: noteY)
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

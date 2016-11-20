//
//  StaffView.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffView: UIView {
  
  var noteWidth: CGFloat = 0.0
  var noteHeight: CGFloat = 0.0 {
    didSet {
      noteWidth = 1.4 * noteHeight
    }
  }

  
  // List of y-value positions of the bar lines on the screen, from high to low
  var barlines = [CGFloat]()
  
  override func drawRect(rect: CGRect) {
    /* Draw bar lines */
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
    
    /* Set note width and height */
    noteHeight = barlines[1] - barlines[0]
  }
  
  
  func tappedView(gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .Ended:
      let location = gesture.locationInView(self)
      print(location.x, ", ", location.y)
      
      addNote(location)
      
      
      /*let note = UIImage(named: "eighth note")
      let noteView = UIImageView(image: note)
      noteView.frame = CGRect(x: 0, y:0, width: note!.size.width, height: note!.size.height)
      self.addSubview(noteView)*/
      
    default:
      break
    }
  }
  
  
  func addNote(tapLocation: CGPoint) {
    let noteX = tapLocation.x - CGFloat(noteWidth/2)
    //let ovalY = tapLocation.y - CGFloat(noteHeight/2)
    let noteY = getNoteBarline(tapLocation.y)
    let notePath = UIBezierPath(ovalInRect: CGRectMake(noteX, noteY, noteWidth, noteHeight))
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = notePath.CGPath
    
    //change the fill color
    shapeLayer.fillColor = UIColor.blackColor().CGColor
    //you can change the stroke color
    shapeLayer.strokeColor = UIColor.blackColor().CGColor
    
    self.layer.addSublayer(shapeLayer)
  }
  
  
  func getNoteBarline(tapY: CGFloat) -> CGFloat {
    let barWidth = barlines[1] - barlines[0]
    var largeBar = barlines[barlines.count-1]  // Larger y-coord
    var smallBar = barlines[0]   // Smaller y-coord
    
    for barlineY in barlines {
      if ( (tapY > barlineY) && (barlineY > smallBar) ) {
        print("Found small bar")
        smallBar = barlineY
      }
      if ( (tapY < barlineY) && (barlineY < largeBar) ) {
        print("Found large bar")
        largeBar = barlineY
      }
      
      if ( abs(tapY - barlineY) < (barWidth/4) ) {
        return barlineY - CGFloat(noteHeight/2)
      }
    }
    print("Got to middle note")
    print("Low bar: ", largeBar)
    print("High bar: ", smallBar)
    let noteY = smallBar + (largeBar-smallBar)/2 - CGFloat(noteHeight/2)
    print(noteY)
    //return (largeBar-smallBar)/2 //- CGFloat(NOTE_HEIGHT/2)
    return noteY
  }
  

}

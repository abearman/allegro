//
//  NoteGestureRecognizer.swift
//  Allegro
//
//  Created by Amy Bearman on 11/22/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

enum StaffGestureState {
  case newNote
  case sharp
  case flat
  case natural
  case measureForwardSwipe
  case measureReverseSwipe
}

class NoteGestureRecognizer: UIGestureRecognizer {
  
  let NATURAL_ERROR = CGFloat(30)
  
  var noteState: StaffGestureState = .newNote
  var numFingers: Int = 1
  
  private var touchedPoints = [CGPoint]() // point history
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    print("Touches began")
    super.touchesBegan(touches, with: event)
    touchedPoints.removeAll()
    
    /* If gesture was made with more than 2 fingers */
    if touches.count == 1 {
      numFingers = 1
    } else if touches.count == 2 {
      numFingers = 2
    } else if touches.count > 2 {
      state = .failed
      print("More than 2 fingers")
    }
    state = .began
  }
  
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    if state == .failed {
      return
    }
    
    let window = view?.window
    if let _ = touches as? Set<UITouch>, let loc = touches.first?.location(in: window) {
      touchedPoints.append(loc)
      state = .changed
    }
  }
  
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    print("Touches ended")
    super.touchesEnded(touches, with: event)
    

    /* If we have only detected a tap gesture */
    if numFingers == 1 {
      if (state != .changed) {
        print("Detected new note tap")
        noteState = .newNote
      
      /* We detected a longer gesture */
      } else {
        if isNatural() {
          noteState = .natural
        } else if isFlat() {
          noteState = .flat
        } else if isSharp() {
          noteState = .sharp
        }
      }
    } else if numFingers == 2 {
      print("Got 2 fingers")
      if isForwardSwipe() {
        noteState = .measureForwardSwipe
      } else if isReverseSwipe() {
        noteState = .measureReverseSwipe
      }
    }
    
    state = .ended
  }
  
  
  
  func isSharp() -> Bool {
    if (touchedPoints.count > 1) {
      let firstPoint = touchedPoints[0]
      let lastPoint = touchedPoints[touchedPoints.count-1]
      
      if ((firstPoint.x < lastPoint.x) && (firstPoint.y > lastPoint.y)) {
        return true
      }
    }
    return false
  }
  
  
  func isFlat() -> Bool {
    if (touchedPoints.count > 1) {
      let firstPoint = touchedPoints[0]
      let lastPoint = touchedPoints[touchedPoints.count-1]
      
      if ((firstPoint.x < lastPoint.x) && (firstPoint.y < lastPoint.y)) {
        return true
      }
    }
    return false
  }
  
  func isNatural() -> Bool {
    if (touchedPoints.count > 1) {
      let firstPoint = touchedPoints[0]
      let lastPoint = touchedPoints[touchedPoints.count-1]
      if ((firstPoint.x < lastPoint.x) &&
            abs(firstPoint.y - lastPoint.y) < NATURAL_ERROR) {
        return true
      }
    }
    return false
  }
  

  func isForwardSwipe() -> Bool {
    if (touchedPoints.count > 1) {
      let firstPoint = touchedPoints[0]
      let lastPoint = touchedPoints[touchedPoints.count-1]
      if (firstPoint.x > lastPoint.x) {
        return true
      }
    }
    return false
  }
  
  func isReverseSwipe() -> Bool {
    if (touchedPoints.count > 1) {
      let firstPoint = touchedPoints[0]
      let lastPoint = touchedPoints[touchedPoints.count-1]
      if (firstPoint.x < lastPoint.x) {
        return true
      }
    }
    return false
  }

}

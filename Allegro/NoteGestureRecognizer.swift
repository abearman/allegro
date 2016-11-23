//
//  NoteGestureRecognizer.swift
//  Allegro
//
//  Created by Amy Bearman on 11/22/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class NoteGestureRecognizer: UIGestureRecognizer {
  
  enum NoteGestureRecognizerState {
    case newNote
    case sharp
    case flat
  }
  
  var noteState: NoteGestureRecognizerState = .newNote
  
  private var touchedPoints = [CGPoint]() // point history
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    print("Touches began")
    super.touchesBegan(touches, with: event)
    
    /* If gesture was made with more than 1 finger */
    if touches.count != 1 {
      state = .failed
      print("More than 1 finger")
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
    if (state != .changed) {
      print("Detected new note tap")
      noteState = .newNote
      state = .ended

    } else {
      if isFlat() {
        noteState = .flat
        state = .ended
      } else if isSharp() {
        noteState = .sharp
        state = .ended
      }
    }
    
  }
  
  
  
  func isSharp() -> Bool {
    let firstPoint = touchedPoints[0]
    let lastPoint = touchedPoints[touchedPoints.count-1]
    
    if (firstPoint.x < lastPoint.x) && (firstPoint.y > lastPoint.y) {
      return true
    }
    return false
  }
  
  
  func isFlat() -> Bool {
    let firstPoint = touchedPoints[0]
    let lastPoint = touchedPoints[touchedPoints.count-1]
    
    if (firstPoint.x < lastPoint.x) && (firstPoint.y < lastPoint.y) {
      return true
    }
    return false
  }
  
  

}

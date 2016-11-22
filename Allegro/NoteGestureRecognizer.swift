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
  
  var isCircle = false
  var tolerance: CGFloat = 0.2
  var fitResult = CircleResult()
  
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
    print("Touches moved")
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
      return
    } else {
      noteState = .sharp
    }
    
    fitResult = fitCircle(points: touchedPoints)
    
    let hasInside = anyPointsInTheMiddle()
    
    isCircle = fitResult.error <= tolerance && !hasInside
    state = isCircle ? .ended : .failed
    print("Is circle? ", isCircle)
  }
  
  
  private func anyPointsInTheMiddle() -> Bool {
    // 1
    let fitInnerRadius = fitResult.radius / sqrt(2) * tolerance
    // 2
    let innerBox = CGRect(
      x: fitResult.center.x - fitInnerRadius,
      y: fitResult.center.y - fitInnerRadius,
      width: 2 * fitInnerRadius,
      height: 2 * fitInnerRadius)
    
    // 3
    var hasInside = false
    for point in touchedPoints {
      if innerBox.contains(point) {
        hasInside = true
        break
      }
    }
    
    return hasInside
  }
  
}

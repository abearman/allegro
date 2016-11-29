//
//  StaffViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/29/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffViewController: UIViewController {

  var composeMode: ComposeMode = ComposeMode.Note {
    didSet {
      updateGestureRecognizers()
    }
  }
  
  var noteDuration: Int = 0 {
    didSet {
      if let staffView = getStaffView() {
        staffView.noteDuration = self.noteDuration
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Set up gestures */
    //updateGestureRecognizers()
  }
  
  
  func getStaffView() -> StaffView? {
    if let staffView = self.view as? StaffView {
      return staffView
    }
    return nil
  }


  // pragma MARK - Gestures
  
  var noteGR: NoteGestureRecognizer!
  var eraseGR: UIPanGestureRecognizer!
  var measureGR: UISwipeGestureRecognizer!
  
  func updateGestureRecognizers() {
    if let staffView = getStaffView() {
      switch composeMode {
      case .Note:
        if eraseGR != nil {
          staffView.removeGestureRecognizer(eraseGR)
        }
        
        self.noteGR = NoteGestureRecognizer(target: self, action: #selector(handleNoteGesture(_:)))
        staffView.addGestureRecognizer(noteGR)
        
      case .Erase:
        if noteGR != nil {
          staffView.removeGestureRecognizer(noteGR)
          noteGR = nil
        }
        
        self.eraseGR = UIPanGestureRecognizer(target: self, action: #selector(handleErase(_:)))
        staffView.addGestureRecognizer(eraseGR)
        
      default:
        break
      }
    }
  }
  
  
  func handleErase(_ gesture: UIPanGestureRecognizer) {
    if let staffView = getStaffView() {
      staffView.handleErasePan(gesture)
    }
  }
  
  
  func handleNoteGesture(_ gesture: NoteGestureRecognizer) {
    if let staffView = getStaffView() {
      let location = gesture.location(in: staffView)
      
      if (gesture.state == .began) {
        staffView.startGesture = location
        
      } else if (gesture.state == .ended) {
        
        switch gesture.noteState {
          /* Add (or select/de-select) a note */
        case StaffGestureState.newNote:
          staffView.gestureAddOrSelectNote(location: location)
          
          /* Add a flat accidental */
        case StaffGestureState.flat:
          staffView.gestureAddFlat()
          
          /* Add a sharp accidental */
        case StaffGestureState.sharp:
          staffView.gestureAddSharp()
          
        case StaffGestureState.leftSwipe:
          let isNaturalSwipe = staffView.gestureLeftSwipe()
          /*if !isNaturalSwipe {
           if let index = staffViews.index(of: self.staffView) {
           if index > 0 {
           let leftStaffView = staffViews[index-1]
           leftStaffView.drawBarLines()
           self.staffView.removeFromSuperview()
           self.view.addSubview(leftStaffView)
           self.staffView = leftStaffView
           self.staffView.setNeedsDisplay()
           }
           }
           }*/
          
        case StaffGestureState.rightSwipe:
          staffView.gestureRightSwipe()
          /*let staffFrame = self.staffView.frame
           self.staffView.removeFromSuperview()
           let newStaffView = StaffView(frame: staffFrame)
           self.view.addSubview(newStaffView)
           self.staffView = newStaffView
           self.staffViews.append(newStaffView)
           self.staffView.setNeedsDisplay()*/
        }
      }
    }
  }

}

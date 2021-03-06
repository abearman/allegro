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
  
  var noteDuration: Int = 2 {
    didSet {
      if let staffView = getStaffView() {
        staffView.noteDuration = self.noteDuration
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Set up gestures */
    updateGestureRecognizers()
    
  }
  
  
  func getStaffView() -> StaffView? {
    if let staffView = self.view as? StaffView {
      return staffView
    }
    return nil
  }


  // pragma MARK - Gestures
  
  var noteGR: NoteGestureRecognizer? = nil
  var eraseGR: UIPanGestureRecognizer? = nil
  
  func updateGestureRecognizers() {
    if let staffView = getStaffView() {
      
      switch composeMode {
      case .Note:
        if eraseGR != nil {
          staffView.removeGestureRecognizer(eraseGR!)
          eraseGR = nil
        }
        
        if noteGR == nil {
          self.noteGR = NoteGestureRecognizer(target: self, action: #selector(handleNoteGesture(_:)))
          staffView.addGestureRecognizer(noteGR!)
        }
        
      case .Erase:
        if noteGR != nil {
          staffView.removeGestureRecognizer(noteGR!)
          noteGR = nil
        }
        
        if eraseGR == nil {
          self.eraseGR = UIPanGestureRecognizer(target: self, action: #selector(handleErase(_:)))
          staffView.addGestureRecognizer(eraseGR!)
        }
        
      default:
        break
      }
      
      /* Printing out the gestures */
      if let gestureRecognizers = staffView.gestureRecognizers {
        for gr in gestureRecognizers {
          print(gr)
        }
      }
      print("")
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
          
        case StaffGestureState.natural:
          staffView.gestureAddNatural()
          
        case StaffGestureState.measureForwardSwipe:
          staffView.gestureMeasureForwardSwipe()
          
        case StaffGestureState.measureReverseSwipe:
          staffView.gestureMeasureReverseSwipe()
        }
      }
    }
  }

}

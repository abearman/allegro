//
//  ComposeViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/15/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  
  /* Reference to right pull-out menu */
  var menuViewController: MenuViewController!
  
  var composeMode: ComposeMode = ComposeMode.Note {
    didSet {
      //staffView.composeMode = self.composeMode
      updateGestureRecognizers()
    }
  }
  
  /* Time signature */
  var topTimeSig: Int = 4 {
    didSet {
      if let _ = staffView {
        staffView.topTimeSig = topTimeSig
      }
    }
  }
  var bottomTimeSig: Int = 4

  /* Note duration panel */
  @IBOutlet var noteButtons: [UIButton]!
  
  @IBOutlet weak var staffView: StaffView!


  override func viewDidLoad() {
      super.viewDidLoad()
    
    /* Auto-select middle note */
    selectNoteButton(noteButtons[noteButtons.count/2])
   
    /* Set up right sliding menu VC */
    setUpMenuVC()
    
    /* Add observer to notification for compose mode change */
    NotificationCenter.default.addObserver(self, selector: #selector(detectComposeModeChange), name: Notification.Name(rawValue: COMPOSE_MODE_NOTIFICATION), object: nil)
    /* Trigger change in StaffView for initial "Note" compose mode */
    self.composeMode = .Note
    
    /* Set up gestures */
    updateGestureRecognizers()
  }
  

  // pragma MARK - Gestures
  
  var noteGR: NoteGestureRecognizer!
  var eraseGR: UIPanGestureRecognizer!
  var measureGR: UISwipeGestureRecognizer!
  
  func updateGestureRecognizers() {
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
      }
      
      self.eraseGR = UIPanGestureRecognizer(target: self, action: #selector(StaffView.handleErasePan(_:)))
      staffView.addGestureRecognizer(eraseGR)
      
    default:
      break
    }
  }
  
  
  func handleNoteGesture(_ gesture: NoteGestureRecognizer) {
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
        staffView.gestureLeftSwipe()
        
      case StaffGestureState.rightSwipe:
        staffView.gestureRightSwipe()
        
      default:
        break
      }
    }
  }
  
  
  // pragma MARK - Menu VC
  
  func setUpMenuVC() {
    if self.revealViewController() != nil {
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      
      if let rightVC = self.revealViewController().rightViewController as? MenuViewController {
        self.menuViewController = rightVC
      }
      
      self.revealViewController().rightViewRevealWidth = RIGHT_MENU_WIDTH
    }
  }
  
  
  /* Propagate change in composition mode from MenuVC to ComposeVC and StaffView */
  func detectComposeModeChange() {
    self.composeMode = ComposeMode(rawValue: menuViewController.modeSegmentedControl.selectedSegmentIndex)!
  }
  
  
  @IBAction func noteDurationChanged(_ sender: UIButton) {
    for noteButton in noteButtons {
      noteButton.backgroundColor = UIColor.white
      setViewBorder(noteButton, color: UIColor.clear, width: 0)
    }
    selectNoteButton(noteButtons[sender.tag])
  }
  
  
  func selectNoteButton(_ noteButton: UIButton) {
    // Highlight the selected note button in blue
    noteButton.backgroundColor = BLUE_COLOR
    setViewBorder(noteButton, color: UIColor.black, width: 1)
    
    // Update the selected duration in the StaffView
    staffView.noteDuration = noteButton.tag
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let timeSigVC = segue.destination as? TimeSignatureViewController {
      timeSigVC.topTimeSig = topTimeSig
      timeSigVC.bottomTimeSig = bottomTimeSig
    }
  }
  
  
  @IBAction func prepareForUnwindToCompose(_ sender: UIStoryboardSegue) {
    /* Transitioning back from time signature screen */
    if let timeSigVC = sender.source as? TimeSignatureViewController {
      
      menuViewController.topTimeSigButton.setImage(UIImage(named: String(timeSigVC.topTimeSig)), for: UIControlState())
      menuViewController.bottomTimeSigButton.setImage(UIImage(named: String(timeSigVC.bottomTimeSig)), for: UIControlState())

      topTimeSig = timeSigVC.topTimeSig
      bottomTimeSig = timeSigVC.bottomTimeSig
    }
    
    /* Transitioning back from key signature screen */
    if let keySigVC = sender.source as? KeySignatureViewController {
      var keySigImageName: String = SHARP_KEYS[0]
      if (keySigVC.numSharps > 0) {
        keySigImageName = SHARP_KEYS[keySigVC.numSharps]
      } else {
        keySigImageName = FLAT_KEYS[keySigVC.numFlats]
      }
      menuViewController.keySigButton.setImage(UIImage(named: keySigImageName), for: UIControlState())

    }
  }

  
}








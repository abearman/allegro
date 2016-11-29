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
  
  /*var composeMode: ComposeMode = ComposeMode.Note {
    didSet {
      if let staffVC = self.staffVC {
        staffVC.composeMode = self.composeMode
      }
    }
  }*/
  
  //var staffVC: StaffViewController!
  
  /*func getStaffView() -> StaffView? {
    if let staffVC = self.staffVC {
      if let staffView = staffVC.view as? StaffView {
        return staffView
      }
    }
    return nil
  }*/
  
  
  /* Time signature */
  var topTimeSig: Int = 4 /*{
    didSet {
      if let staffView = getStaffView() {
        staffView.topTimeSig = topTimeSig
      }
    }
  }*/
  var bottomTimeSig: Int = 4

  /* Note duration panel */
  @IBOutlet var noteButtons: [UIButton]!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Set up reference to container Staff View Controller */
    /*for childVC in self.childViewControllers {
      if let staffVC = childVC as? StaffViewController {
        self.staffVC = staffVC
      }
    }*/
    
    /* Auto-select middle note */
    //selectNoteButton(noteButtons[noteButtons.count/2])
   
    /* Set up right sliding menu VC */
    setUpMenuVC()
    
    /* Add observer to notification for compose mode change */
    /*NotificationCenter.default.addObserver(self, selector: #selector(detectComposeModeChange), name: Notification.Name(rawValue: COMPOSE_MODE_NOTIFICATION), object: nil)
    /* Trigger change in StaffVC for initial "Note" compose mode */
    self.composeMode = .Note*/
    
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
  
  
  /* Propagate change in composition mode from MenuVC to ComposeVC and to StaffVC */
  /*func detectComposeModeChange() {
    self.composeMode = ComposeMode(rawValue: menuViewController.modeSegmentedControl.selectedSegmentIndex)!
  }*/
  
  
  /*@IBAction func noteDurationChanged(_ sender: UIButton) {
    for noteButton in noteButtons {
      noteButton.backgroundColor = UIColor.white
      setViewBorder(noteButton, color: UIColor.clear, width: 0)
    }
    selectNoteButton(noteButtons[sender.tag])
  }*/
  
  
  /*func selectNoteButton(_ noteButton: UIButton) {
    // Highlight the selected note button in blue
    noteButton.backgroundColor = BLUE_COLOR
    setViewBorder(noteButton, color: UIColor.black, width: 1)
    
    // Update the selected duration in the StaffVC
    staffVC.noteDuration = noteButton.tag
  }*/
  
  
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








//
//  ComposeViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/15/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  
  /* pragma MARK - Model: the composition being constructed */
  var composition: Composition = Composition()
  @IBOutlet weak var compositionNameLabel: UILabel!
  
  var currentMeasureNum: Int = 0
  
  
  var composeMode: ComposeMode = ComposeMode.Note {
    didSet {
      if let staffVC = self.staffVC {
        staffVC.composeMode = self.composeMode
      }
    }
  }
  
  var staffVC: StaffViewController!
  
  func getStaffView() -> StaffView? {
    if let staffVC = self.staffVC {
      if let staffView = staffVC.view as? StaffView {
        return staffView
      }
    }
    return nil
  }
  

  /* Note duration panel */
  @IBOutlet var noteButtons: [UIButton]!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if !composition.name.isEmpty {
      self.compositionNameLabel.text = composition.name
    } else {
      showCompositionNameAlert()
    }
    
    /* Detect when the internal StaffVC is changed via a measure swipe */
    updateDisplayedStaffVC()
    NotificationCenter.default.addObserver(self, selector: #selector(updateDisplayedStaffVC), name: Notification.Name(rawValue: MEASURE_SWIPE_FORWARD_NOTIFICATION), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateDisplayedStaffVC), name: Notification.Name(rawValue: MEASURE_SWIPE_REVERSE_NOTIFICATION), object: nil)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Auto-select quarter note */
    selectNoteButton(noteButtons[2], 2)
    
    /* Set up right sliding menu VC */
    setUpMenuVC()
    
    /* Add observer to notification for compose mode change */
    NotificationCenter.default.addObserver(self, selector: #selector(detectComposeModeChange), name: Notification.Name(rawValue: COMPOSE_MODE_NOTIFICATION), object: nil)
  }
  
  // pragma MARK - AlertController for entering Composition name
  
  var inputTextField: UITextField?
  
  func showCompositionNameAlert() {
    let alertController = UIAlertController(title: "Enter a title for your composition", message: "", preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
      self.compositionNameLabel.text = self.inputTextField?.text
      self.composition.name = (self.inputTextField?.text)!
    }))
 
    alertController.addTextField(configurationHandler: {(textField: UITextField!) in
      textField.placeholder = "New Composition"
      self.inputTextField = textField
      self.inputTextField?.autocapitalizationType = UITextAutocapitalizationType.words
    })
    present(alertController, animated: true, completion: nil)
  }
  
  
  
  /* Updates the ComposeVC's state and the displayed StaffView's state when a measure swipe is detected */
  func updateDisplayedStaffVC() {
    for childVC in self.childViewControllers {
      if let pageVC = childVC as? StaffPageViewController {
        let displayedStaffVC = pageVC.orderedViewControllers[pageVC.currentIndex]
        
        /* Update the ComposeVC's state */
        self.staffVC = displayedStaffVC
        currentMeasureNum = pageVC.currentIndex
        
        /* Update the Composition state with a new Measure */
        if currentMeasureNum >= composition.measures.count {
          composition.measures.append(Measure())
        }
        
        /* Update the displayed StaffView's state */
        if let staffView = getStaffView() {
          staffView.measure = composition.measures[currentMeasureNum]
        }
      }
    }
  }
  
  
  // pragma MARK - Menu VC
  
  /* Reference to right pull-out menu */
  var menuViewController: MenuViewController!
  
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
  func detectComposeModeChange() {
    self.composeMode = ComposeMode(rawValue: menuViewController.modeSegmentedControl.selectedSegmentIndex)!
  }
  
  
  @IBAction func noteDurationChanged(_ sender: UIButton) {
    for noteButton in noteButtons {
      noteButton.backgroundColor = UIColor.white
      setViewBorder(noteButton, color: UIColor.clear, width: 0)
    }
    selectNoteButton(noteButtons[sender.tag], sender.tag)
  }
  
  
  func selectNoteButton(_ noteButton: UIButton, _ tag: Int) {
    // Update the selected duration in the StaffVC
    if staffVC != nil {
      staffVC.noteDuration = tag
    }
    
    // Highlight the selected note button in blue
    noteButton.backgroundColor = BLUE_COLOR
    setViewBorder(noteButton, color: UIColor.black, width: 1)
  }
  
  
  @IBAction func prepareForUnwindToCompose(_ sender: UIStoryboardSegue) {
    /* Transitioning back from time signature screen */
    if let timeSigVC = sender.source as? TimeSignatureViewController {
      
      /* Set the time signature images in the MenuVC */
      menuViewController.topTimeSigButton.setImage(UIImage(named: String(timeSigVC.topTimeSig)), for: UIControlState())
      menuViewController.bottomTimeSigButton.setImage(UIImage(named: String(timeSigVC.bottomTimeSig)), for: UIControlState())
      
      /* Set the time signature in the current measure */
      composition.measures[currentMeasureNum].timeSignature = TimeSignature(timeSigVC.topTimeSig, timeSigVC.bottomTimeSig)
    }
    
    /* Transitioning back from key signature screen */
    if let keySigVC = sender.source as? KeySignatureViewController {
      var keySigImageName: String = SHARP_KEYS[0]
      if (keySigVC.numSharps > 0) {
        keySigImageName = SHARP_KEYS[keySigVC.numSharps]
      } else {
        keySigImageName = FLAT_KEYS[keySigVC.numFlats]
      }
      /* Set the key signature image in the MenuVC */
      menuViewController.keySigButton.setImage(UIImage(named: keySigImageName), for: UIControlState())
      
      /* Set the key signature in the current measure */
      composition.measures[currentMeasureNum].keySignature = KeySignature(keySigVC.numSharps, keySigVC.numFlats)
    }
  }


  
}








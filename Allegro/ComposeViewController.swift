//
//  ComposeViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/15/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  
  /* Time signature */
  @IBOutlet weak var topTimeSigButton: UIButton!
  @IBOutlet weak var bottomTimeSigButton: UIButton!
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
  
  @IBOutlet weak var staffView: StaffView! {
    /* Add gesture recognizers */
    didSet {
      /*staffView.addGestureRecognizer(UIPanGestureRecognizer(
        target: staffView, action: #selector(StaffView.handlePan(_:))
      ))*/
      
      /*staffView.addGestureRecognizer(UITapGestureRecognizer(
        target: staffView, action: #selector(StaffView.tappedView(_:))
      ))*/
      
      staffView.addGestureRecognizer(NoteGestureRecognizer(target: staffView, action: #selector(StaffView.handleNoteGesture(_:))
      ))
      
    }
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    /* Auto-select middle note */
    selectNoteButton(noteButtons[noteButtons.count/2])
   
    if self.revealViewController() != nil {
      /*slideButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)*/

      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

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
    if let timeSigVC = sender.source as? TimeSignatureViewController {
      topTimeSigButton.setImage(UIImage(named: String(timeSigVC.topTimeSig)), for: UIControlState())
      bottomTimeSigButton.setImage(UIImage(named: String(timeSigVC.bottomTimeSig)), for: UIControlState())
      
      topTimeSig = timeSigVC.topTimeSig
      bottomTimeSig = timeSigVC.bottomTimeSig
    }
  }

  @IBOutlet weak var menuView: UIView!

  
}








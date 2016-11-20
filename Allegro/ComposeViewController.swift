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
  var topTimeSig: Int = 4
  var bottomTimeSig: Int = 4

  /* Note duration panel */
  @IBOutlet weak var notesView: UIView!
  @IBOutlet var noteButtons: [UIButton]!
  
  @IBOutlet weak var staffView: StaffView! {
    /* Add gesture recognizers */
    didSet {
      staffView.addGestureRecognizer(UITapGestureRecognizer(
        target: staffView, action: #selector(StaffView.tappedView(_:))
      ))
    }
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    notesView.backgroundColor = UIColor.whiteColor()
    notesView.layer.borderWidth = 1
    notesView.layer.borderColor = UIColor.blackColor().CGColor
    
    // Auto-select middle note
    selectNoteButton(noteButtons[noteButtons.count/2])
  }
  

  @IBAction func noteDurationChanged(sender: UIButton) {
    for noteButton in noteButtons {
      noteButton.superview?.backgroundColor = UIColor.whiteColor()
      setViewBorder(noteButton.superview!, color: UIColor.clearColor(), width: 0)
    }
    
    selectNoteButton(sender)
  }
  
  
  func selectNoteButton(noteButton: UIButton) {
    // Highlight the selected note button in blue
    noteButton.superview?.backgroundColor = BLUE_COLOR
    setViewBorder(noteButton.superview!, color: UIColor.blackColor(), width: 1)
    
    // Update the selected duration in the StaffView
    staffView.noteDuration = noteButton.tag
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let timeSigVC = segue.destinationViewController as? TimeSignatureViewController {
      timeSigVC.topTimeSig = topTimeSig
      timeSigVC.bottomTimeSig = bottomTimeSig
    }
  }
  
  
  @IBAction func prepareForUnwindToCompose(sender: UIStoryboardSegue) {
    if let timeSigVC = sender.sourceViewController as? TimeSignatureViewController {
      topTimeSigButton.setImage(UIImage(named: String(timeSigVC.topTimeSig)), forState: .Normal)
      bottomTimeSigButton.setImage(UIImage(named: String(timeSigVC.bottomTimeSig)), forState: .Normal)
      
      topTimeSig = timeSigVC.topTimeSig
      bottomTimeSig = timeSigVC.bottomTimeSig
    }
  }


  
}

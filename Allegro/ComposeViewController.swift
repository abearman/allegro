//
//  ComposeViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/15/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

  @IBOutlet weak var notesView: UIView!
  @IBOutlet var noteButtons: [UIButton]!
  @IBOutlet weak var staffView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      notesView.backgroundColor = UIColor.whiteColor()
      notesView.layer.borderWidth = 1
      notesView.layer.borderColor = UIColor.blackColor().CGColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func noteDurationChanged(sender: UIButton) {
    print(sender.tag)
    
    for noteButton in noteButtons {
      noteButton.superview?.backgroundColor = UIColor.whiteColor()
      setViewBorder(noteButton.superview!, color: UIColor.clearColor(), width: 0)
    }
    
    sender.superview?.backgroundColor = BLUE_COLOR
    setViewBorder(sender.superview!, color: UIColor.blackColor(), width: 1)
  }
  
  @IBAction func prepareForUnwindToCompose(sender: UIStoryboardSegue) {
    // No code needed here
  }

  
}

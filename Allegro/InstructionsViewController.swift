//
//  InstructionsViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/15/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

  @IBOutlet weak var gesturesLabel: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    gesturesLabel.layer.borderWidth = 1
    gesturesLabel.layer.borderColor = UIColor.black.cgColor
    
    doneButton.layer.borderWidth = 2
    doneButton.layer.borderColor = UIColor.black.cgColor
  }
    
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}

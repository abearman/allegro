//
//  MenuViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/27/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

enum ComposeMode: Int {
  case Note = 0
  case Erase = 1
  case Dynamics = 2
}

class MenuViewController: UIViewController {

  var shouldSaveComposition = true
  
  var composeMode = ComposeMode.Note
  @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
  
  @IBOutlet weak var topTimeSigButton: UIButton!
  @IBOutlet weak var bottomTimeSigButton: UIButton!
  
  @IBOutlet weak var keySigButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func modeChanged(_ sender: Any) {
    composeMode = ComposeMode(rawValue: modeSegmentedControl.selectedSegmentIndex)!
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: COMPOSE_MODE_NOTIFICATION)))
  }
  
  
  // pragma MARK - AlertController for saving Composition
  
  func showCompositionSaveAlert() {
    let alertController = UIAlertController(title: "Do you want to save your composition?", message: "", preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
      print("pressed save")
      self.performSegue(withIdentifier: "Unwind To Home", sender: self)
    }))
    
    alertController.addAction(UIAlertAction(title: "Don't Save", style: UIAlertActionStyle.destructive, handler: { (action) -> Void in
      print("pressed don't save")
    }))
    
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func goHome(_ sender: Any) {
    showCompositionSaveAlert()
  }
  
  
}

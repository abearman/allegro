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
  var compositions: [Composition] = []
  
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
      self.shouldSaveComposition = true
      self.performSegue(withIdentifier: "Unwind To Home", sender: self)
    }))
    
    alertController.addAction(UIAlertAction(title: "Don't Save", style: UIAlertActionStyle.destructive, handler: { (action) -> Void in
      print("pressed don't save")
      self.shouldSaveComposition = false
      self.performSegue(withIdentifier: "Unwind To Home", sender: self)
    }))
    
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func goHome(_ sender: Any) {
    showCompositionSaveAlert()
  }
  
  
  func showCompositionWasSavedAlert() {
    let alertController = UIAlertController(title: "Composition Saved", message: "", preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) -> Void in
      /*if let revealVC = self.revealViewController() {
        if let composeVC = revealVC.frontViewController as? ComposeViewController {
          if let navigationVC = self.navigationController {
            for vc in navigationVC.viewControllers {
              if let homeVC = vc as? HomeViewController {
                homeVC.saveComposition(menuVC: self, composeVC: composeVC)
                self.compositions = homeVC.compositions
              }
            }
          }
        }
      }*/
      
      
      //self.performSegue(withIdentifier: "See All Compositions", sender: self)
    }))
  
    present(alertController, animated: true, completion: nil)
  }
  
  
  @IBAction func saveAndSeeOtherCompositions(_ sender: Any) {
    showCompositionWasSavedAlert()
  }
  
  /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "See All Compositions" {
      if let ctvc = segue.destination as? CompositionsTableViewController {
        ctvc.compositions = self.compositions
      }
    }
  }*/
}

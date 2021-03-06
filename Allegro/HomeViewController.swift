//
//  HomeViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/14/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var newCompButton: UIButton!
  @IBOutlet weak var instructionsButton: UIButton!
  @IBOutlet weak var editCompositionButton: UIButton!
  
  /* List of Compositions for the session */
  var compositions: [Composition] = [Composition]()
  
  var lastMoveWasNewComposition: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.isNavigationBarHidden = true
    
    newCompButton.layer.borderWidth = BORDER_WIDTH
    newCompButton.layer.borderColor = UIColor.black.cgColor
    
    instructionsButton.layer.borderWidth = BORDER_WIDTH
    instructionsButton.layer.borderColor = UIColor.black.cgColor
    
    editCompositionButton.layer.borderWidth = BORDER_WIDTH
    editCompositionButton.layer.borderColor = UIColor.black.cgColor
    
    /* Listens for compositions that are deleted */
    NotificationCenter.default.addObserver(self, selector: #selector(deleteComposition), name: Notification.Name(rawValue: DELETE_COMPOSITION_NOTIFICATION), object: nil)
  }
  
  
  func deleteComposition() {
    for childVc in self.childViewControllers {
      if let ctvc = childVc as? CompositionsTableViewController {
        self.compositions = ctvc.compositions
      }
    }
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    //self.navigationController?.isNavigationBarHidden = false
  }
  
  
  /* Prepare for segue to ComposeVC */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    /* We're creating a new Composition */
    if segue.destination is SWRevealViewController {
      lastMoveWasNewComposition = true
    } else if let ctvc = segue.destination as? CompositionsTableViewController {
      lastMoveWasNewComposition = false
      ctvc.compositions = self.compositions
    }
  }
  
  
  @IBAction func prepareForUnwindToHome(_ sender: UIStoryboardSegue) {
    if let menuVC = sender.source as? MenuViewController {
      if let revealVC = menuVC.revealViewController() {
        if let composeVC = revealVC.frontViewController as? ComposeViewController {
          saveComposition(menuVC: menuVC, composeVC: composeVC)
        }
      }
    }
      
    /*if let menuVC = composeVC.revealViewController() {
      menuVC.revealToggle(animated: true)
    }*/
  }
  
  func saveComposition(menuVC: MenuViewController, composeVC: ComposeViewController) {
    /* Only save if they said they wanted to */
    if menuVC.shouldSaveComposition {
      /* Append the new Composition */
      if lastMoveWasNewComposition {
        composeVC.composition.date = Date()
        compositions.append(composeVC.composition)
        
        /* Update the existing Composition */
      } else {
        if let editIndex = compositions.index(of: composeVC.composition) {
          compositions[editIndex] = composeVC.composition
        }
      }
    }
  }

}

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
  
  /* List of Compositions for the session */
  var compositions: [Composition] = [Composition]()
  
  var lastMoveWasNewComposition: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.isNavigationBarHidden = true
    
    newCompButton.layer.borderWidth = 2
    newCompButton.layer.borderColor = UIColor.black.cgColor
    
    instructionsButton.layer.borderWidth = 2
    instructionsButton.layer.borderColor = UIColor.black.cgColor
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    //self.navigationController?.navigationBarHidden = false
  }
  
  
  /* Prepare for segue to ComposeVC */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    /* We're creating a new Composition */
    if let revealVC = segue.destination as? SWRevealViewController {
      lastMoveWasNewComposition = true
    } else {
      lastMoveWasNewComposition = false
    }
 
    /* We're creating a new Composition */
    /*if let revealVC = segue.destination as? SWRevealViewController {
      revealVC.loadView()
      if let composeVC = revealVC.frontViewController as? ComposeViewController {
        var newComposition: UnsafeMutablePointer<Composition> = UnsafeMutablePointer.allocate(capacity: 1)
        newComposition.pointee = Composition()
        let blah = newComposition.pointee
        
        composeVC._composition = newComposition
        composeVC._composition.pointee = newComposition.pointee
        compositions.append(newComposition)
      }
      revealVC.loadView()
    }*/
  }
  
  
  @IBAction func prepareForUnwindToHome(_ sender: UIStoryboardSegue) {
    if let menuVC = sender.source as? MenuViewController {
      if let revealVC = menuVC.revealViewController() {
        if let composeVC = revealVC.frontViewController as? ComposeViewController {
          
          /* Append the new Composition */
          if lastMoveWasNewComposition {
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
    
    /*if let composeVC = sender.source as? ComposeViewController {
      /* Append the new Composition */
      if lastMoveWasNewComposition {
        compositions.append(composeVC.composition)
        
      /* Update the existing Composition */
      } else {
        if let editIndex = compositions.index(of: composeVC.composition) {
          compositions[editIndex] = composeVC.composition
        }
      }
      
      /*if let menuVC = composeVC.revealViewController() {
        menuVC.revealToggle(animated: true)
      }*/
    }*/
  }
  
  
}

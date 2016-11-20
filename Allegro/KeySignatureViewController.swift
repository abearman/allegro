//
//  KeySignatureViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class KeySignatureViewController: UIViewController {

  let MAX_ACCIDENTALS: Int = 7
  
  var numSharps: Int = 0
  var numFlats: Int = 0
  
  let sharpKeys = ["C Major / A Minor", "G Major / E Minor", "D Major / B Minor",
                   "A Major / F♯ Minor", "E Major / C♯ Minor", "B Major / G♯ Minor",
                   "F♯ Major / D♯ Minor", "C♯ Major / A♯ Minor"]
  
  let flatKeys = ["C Major / A Minor", "F Major / D Minor", "B♭ Major / G Minor",
                   "E♭ Major / C Minor", "A♭ Major / F Minor", "D♭ Major / B♭ Minor",
                   "G♭ Major / E♭ Minor", "C♭ Major / A♭ Minor"]
  
  @IBOutlet weak var keySignatureLabel: UILabel!
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet var sharpImages: [UIImageView]!
  @IBOutlet var flatImages: [UIImageView]!

  @IBOutlet weak var sharpView: UIView!
  @IBOutlet weak var flatView: UIView!
  @IBOutlet weak var buttonView: UIView!
  @IBOutlet weak var keySigLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    buttonView.layer.borderColor = UIColor.blackColor().CGColor
    buttonView.layer.borderWidth = 2
    
    sharpView.layer.borderColor = UIColor.blackColor().CGColor
    sharpView.layer.borderWidth = 2
    
    flatView.layer.borderColor = UIColor.blackColor().CGColor
    flatView.layer.borderWidth = 2
    
    doneButton.layer.borderColor = UIColor.blackColor().CGColor
    doneButton.layer.borderWidth = 2
    
    keySignatureLabel.layer.borderColor = UIColor.blackColor().CGColor
    keySignatureLabel.layer.borderWidth = 1
  }

    
  @IBAction func sharpButtonClicked(sender: AnyObject) {
    // If we've already clicked at least one flat, can't use any sharps
    if (numSharps >= MAX_ACCIDENTALS) {
      showAlertWithTitle("Too many sharps!", subtitle: "You can only enter up to 7 sharps.");
      return
    }
    
    // Add a sharp
    if (numFlats == 0) {
      flatView.hidden = true
      sharpView.hidden = false
      sharpImages[numSharps].hidden = false
      numSharps += 1
      keySigLabel.text = sharpKeys[numSharps]
      
    // Subtract a flat
    } else {
      numFlats -= 1
      flatImages[numFlats].hidden = true
      keySigLabel.text = flatKeys[numFlats]
    }
    
    
  }


  @IBAction func flatButtonClicked(sender: AnyObject) {
    // If we've already clicked at least one sharp, can't use any flats
    if (numFlats >= MAX_ACCIDENTALS) {
      showAlertWithTitle("Too many flats!", subtitle: "You can only enter up to 7 flats.");
      return
    }
    
    // Add a flat
    if (numSharps == 0) {
      flatView.hidden = false
      sharpView.hidden = true
      flatImages[numFlats].hidden = false
      numFlats += 1
      keySigLabel.text = flatKeys[numFlats]
      
    // Subtract a sharp
    } else {
      numSharps -= 1
      sharpImages[numSharps].hidden = true
      keySigLabel.text = sharpKeys[numSharps]
    }
  }
  
  
  func showAlertWithTitle(title: String, subtitle: String) {
    let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .Alert)
    
    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(defaultAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }

}
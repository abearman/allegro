//
//  TimeSignatureViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/18/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class TimeSignatureViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

  @IBOutlet weak var timeSignatureLabel: UILabel!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var picker: UIPickerView!
  
  let pickerData: [Int] = Array(1...8)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timeSignatureLabel.layer.borderWidth = 1
    timeSignatureLabel.layer.borderColor = UIColor.blackColor().CGColor
    
    doneButton.layer.borderColor = UIColor.blackColor().CGColor
    doneButton.layer.borderWidth = 2
    
    picker.delegate = self
    picker.dataSource = self

  }

  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 2
  }
  
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }

  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(pickerData[row])
  }
  
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    picker.reloadAllComponents()
  }
  
}

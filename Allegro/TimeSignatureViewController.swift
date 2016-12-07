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
  
  let pickerData: [Int] = [2, 3, 4, 6, 8]
  
  var topTimeSig: Int = 4
  var bottomTimeSig: Int = 4
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timeSignatureLabel.layer.borderWidth = 1
    timeSignatureLabel.layer.borderColor = UIColor.black.cgColor
    
    doneButton.layer.borderColor = UIColor.black.cgColor
    doneButton.layer.borderWidth = 2
    
    picker.delegate = self
    picker.dataSource = self
    
    /* Set default selected time signature to whatever was last selected */
    picker.selectRow(pickerData.index(of: topTimeSig)!, inComponent: 0, animated: true)
    
    picker.selectRow(pickerData.index(of: bottomTimeSig)!, inComponent: 1, animated: true)
  }

  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }

  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(pickerData[row])
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    /* Top time signature */
    if (component == 0) {
      topTimeSig = pickerData[row]
    /* Bottom time signature */
    } else if (component == 1) {
      bottomTimeSig = pickerData[row]
    }
    
    picker.reloadAllComponents()
  }
  
}

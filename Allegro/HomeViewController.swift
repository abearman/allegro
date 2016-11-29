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
  
  
  @IBAction func prepareForUnwindToHome(_ sender: UIStoryboardSegue) {
    // No code needed here
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

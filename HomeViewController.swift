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
    
    self.navigationController?.navigationBarHidden = true

    newCompButton.layer.borderWidth = 1
    newCompButton.layer.borderColor = UIColor.blackColor().CGColor
  
    instructionsButton.layer.borderWidth = 1
    instructionsButton.layer.borderColor = UIColor.blackColor().CGColor
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func viewWillDisappear(animated: Bool) {
    self.navigationController?.navigationBarHidden = false
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

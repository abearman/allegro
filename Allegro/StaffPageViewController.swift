//
//  StaffPageViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/29/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffPageViewController: UIPageViewController {

  private(set) lazy var orderedViewControllers: [StaffViewController] = {
    return [self.newStaffVC(), self.newStaffVC(), self.newStaffVC(), self.newStaffVC()]
  }()
  
  var currentIndex: Int = 0
  
  private func newStaffVC() -> StaffViewController {
    return UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "StaffVC") as! StaffViewController
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Add observers to notification for measure swipes */
    NotificationCenter.default.addObserver(self, selector: #selector(measureSwipeForward), name: Notification.Name(rawValue: MEASURE_SWIPE_FORWARD_NOTIFICATION), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(measureSwipeReverse), name: Notification.Name(rawValue: MEASURE_SWIPE_REVERSE_NOTIFICATION), object: nil)
    
    if let firstVC = orderedViewControllers.first {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
  }
  
  
  func measureSwipeForward() {
    let nextIndex = currentIndex + 1
    if nextIndex < orderedViewControllers.count {
      let currStaffVC = orderedViewControllers[currentIndex]
      let nextStaffVC = orderedViewControllers[nextIndex]
      nextStaffVC.composeMode = currStaffVC.composeMode
      setViewControllers([nextStaffVC], direction: .forward, animated: true, completion: nil)
      currentIndex += 1
    }
    
  }
  
  func measureSwipeReverse() {
    let prevIndex = currentIndex - 1
    if prevIndex >= 0 {
      let currStaffVC = orderedViewControllers[currentIndex]
      let prevStaffVC = orderedViewControllers[prevIndex]
      prevStaffVC.composeMode = currStaffVC.composeMode
      setViewControllers([orderedViewControllers[prevIndex]], direction: .reverse, animated: true, completion: nil)
      currentIndex -= 1
    }
  }
  



}

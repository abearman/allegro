//
//  StaffPageViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 11/29/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class StaffPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

  private(set) lazy var orderedViewControllers: [StaffViewController] = {
    return [self.newStaffVC(), self.newStaffVC(), self.newStaffVC()]
  }()
  
  var currentIndex: Int = 0
  
  private func newStaffVC() -> StaffViewController {
    return UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "StaffVC") as! StaffViewController
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    
    if let firstVC = orderedViewControllers.first {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return nil
  }


}

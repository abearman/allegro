
//
//  UIViewExtensions.swift
//  Allegro
//
//  Created by Amy Bearman on 11/27/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

extension UIView {
  // Name this function in a way that makes sense to you...
  // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
  func slideInFromRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
    // Create a CATransition animation
    let slideInFromRightTransition = CATransition()
    
    // Set its callback delegate to the completionDelegate that was provided (if any)
    /*if let delegate: AnyObject = completionDelegate {
      slideInFromLeftTransition.delegate = delegate
    }*/
    
    // Customize the animation's properties
    slideInFromRightTransition.type = kCATransitionPush
    slideInFromRightTransition.subtype = kCATransitionFromRight
    slideInFromRightTransition.duration = duration
    slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    slideInFromRightTransition.fillMode = kCAFillModeRemoved
    
    // Add the animation to the View's layer
    self.layer.add(slideInFromRightTransition, forKey: "slideInFromRightTransition")
  }
}

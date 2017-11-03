//
//  UIViewExt.swift
//  BookMoney
//
//  Created by Boris Esanu on 4/27/17.
//  Copyright © 2017 MDS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addBlur(_ style: UIBlurEffectStyle!) {
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = UIColor.white
        }
    }
}

//
//  ButtonExt.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import Foundation
import UIKit

extension UIButton {
    
    func updateButtonForAppleTV() {
        
        self.setBackgroundImage(UIImage.init(color: UIColor.mainOrangeColor()), for: .focused)
        self.setBackgroundImage(UIImage.init(color: UIColor.init(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0)), for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .focused)
    }
}

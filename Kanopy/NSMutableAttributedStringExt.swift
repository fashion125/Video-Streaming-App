//
//  NSMutableAttributedStringExt.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 19/06/2017.
//
//

import Foundation


extension NSMutableAttributedString {

    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
    
}

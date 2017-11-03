//
//  ArrayExt.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/24/17.
//
//

import Foundation

extension Array {
    
    func subjectModelsArrayToString() -> String {
        
        let mstr: NSMutableString = NSMutableString.init()
        
        for (index, subjectItem) in self.enumerated() {
            
            let sm: SubjectModel = subjectItem as! SubjectModel
            
            if index == 0 {
                mstr.append(sm.name)
            } else {
                mstr.append(", " + sm.name)
            }
        }
        
        return String(mstr)
    }
}

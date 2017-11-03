//
//  RatingModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/24/17.
//
//

import UIKit

class RatingModel: NSObject {
    
    private(set) var count: Int! = 0
    private(set) var average: Int! = 0
    
    
    // MARK: - Init methods 
    
    
    init(count: Int, average: Int) {
        super.init()
        
        self.count = count
        self.average = average
    }
}

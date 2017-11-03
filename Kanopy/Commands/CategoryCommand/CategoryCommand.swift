//
//  CategoryCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class CategoryCommand: ShelfCommand {

    private(set) var delegate: CategoryVCDelegate!
    private(set) var categoryVC: CategoryVC!
    
    // MARK: - Init methods 
    
    
    init(delegate: CategoryVCDelegate!, categoryVC: CategoryVC!) {
        super.init()
        
        self.delegate = delegate
        self.categoryVC = categoryVC
    }
}

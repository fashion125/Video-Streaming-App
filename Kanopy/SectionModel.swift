//
//  SectionModel.swift
//  optum-soft-install-app
//
//  Created by Ilya Katrenko on 9/26/16.
//  Copyright © 2016 Design and Test Lab. All rights reserved.
//

import UIKit

class SectionModel: NSObject {
    
    /** View for header in section. */
    private(set) var headerView: UIView? = nil
    
    /** List of cell models for section. */
    var cellModels: [GenericCellModel] = []
    
    var sectionLineSpacing: CGFloat = 0.0
    
    /** View for footer in section. */
    private(set) var footerView: UIView? = nil
    
    /** Creates and returns new section model instance using given cell models.
     - parameter cellModels:    List of cell models.
     */
    init(cellModels: [GenericCellModel]) {
        super.init()
        self.headerView = nil
        self.cellModels = cellModels
        self.footerView = nil
    }
    
    /** Creates and returns new section model instance using given parameters.
     - parameter headerView:    View for header in section.
     - parameter cellModels:    List of cell models.
     - parameter footerView:    View for footer in section.
     */
    init(headerView: UIView,
         cellModels: [GenericCellModel],
         footerView: UIView) {
        super.init()
        self.headerView = headerView
        self.cellModels = cellModels
        self.footerView = footerView
    }
    
    /** Allow to update cell models of section.
     - parameter cellModels:    List of new cell models.
     */
    func updateCellModels(cellModels: [GenericCellModel]) {
        self.cellModels = cellModels
    }
    
}

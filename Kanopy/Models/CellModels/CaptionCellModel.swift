//
//  CaptionCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/20/17.
//
//

import UIKit
import AVFoundation

class CaptionCellModel: GenericCellModel {

    private(set) var titleValue: String = ""
    private(set) var caption: AVMediaSelectionOption?
    
    
    // MARK: - Init method
    
    
    init(title: String!, caption: AVMediaSelectionOption?, isSelected: Bool) {
        super.init(TableCellIDs.captionTableCell, height: 50.0)
        
        self.titleValue = title
        self.caption = caption
        self.isSelected = isSelected
    }
}

//
//  TitleCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

class TitleCollectionCell: GenericCollectionCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.titleCM.title
    }
    
    
    var titleCM: TitleCellModel {
        get {
            return self.cellModel as! TitleCellModel
        }
    }
}

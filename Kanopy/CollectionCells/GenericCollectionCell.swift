//
//  GenericCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit

class GenericCollectionCell: UICollectionViewCell {
    
    private(set) var cellModel: GenericCellModel?
    
    func configure(cellModel: GenericCellModel) {
        self.cellModel = cellModel
    }
}

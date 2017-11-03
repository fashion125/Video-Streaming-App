//
//  GenericCell.swift
//  optum-soft-install-app
//
//  Created by Ilya Katrenko on 9/26/16.
//  Copyright © 2016 Design and Test Lab. All rights reserved.
//

import UIKit

class GenericCell: UITableViewCell {

    private(set) var cellModel: GenericCellModel?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
    func configure(cellModel: GenericCellModel) {
        self.cellModel = cellModel
    }
    
    
    func didSelectCell() {
        
    }
}

//
//  LoadCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 06.05.17.
//
//

import UIKit

class LoadCollectionCell: GenericCollectionCell {

    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.loadIndicator.startAnimating()
    }
}

//
//  LoadTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/19/17.
//
//

import UIKit

class LoadTableCell: GenericCell {

    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    
    // MARK: - 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorHeight.constant = 0.5
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.loadIndicator.startAnimating()
        
        self.separatorView.isHidden = (self.cellModel?.isHideSeparator)!
    }
    
}

//
//  CategoryTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/31/17.
//
//

import UIKit

class CategoryTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.cornerRadius = 8.0
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.categoryCM.category.name
        self.updateButton(false)
    }
    
    
    var categoryCM: CategoryCellModel {
        get {
            return self.cellModel as! CategoryCellModel
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.updateButton(true)
    }
    
    
    private func updateButton(_ isAnimated: Bool!) {
        if self.isFocused {
            self.focusedAnimation(isAnimated)
        } else {
            self.notFocusedAnimation(isAnimated)
        }
    }
    
    
    private func focusedAnimation(_ isAnimated: Bool!) {
        
        if !isAnimated {
            self.updateForFocus()
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.updateForFocus()
        }
    }
    
    
    private func notFocusedAnimation(_ isAnimated: Bool!) {
        
        if !isAnimated {
            self.updateForNotFocus()
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.updateForNotFocus()
        }
    }
    
    
    private func updateForFocus() {
        self.titleLabel.layer.opacity = 1.0
        self.contentView.backgroundColor = UIColor.mainOrangeColor()
        
        self.layoutIfNeeded()
    }
    
    
    private func updateForNotFocus() {
        self.titleLabel.layer.opacity = 0.4
        self.contentView.backgroundColor = UIColor.clear
        
        self.layoutIfNeeded()
    }
}

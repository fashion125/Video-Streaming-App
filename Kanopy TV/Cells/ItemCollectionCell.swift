//
//  ItemCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/20/17.
//
//

import UIKit

class ItemCollectionCell: GenericCollectionCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: -
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.thumbImageView.sd_setImage(with: URL.init(string: (self.itemCM.item.images?.mediumThumbURL())!))
        self.titleLabel.text = self.itemCM.item.title
    }
    
    
    var itemCM: ItemCellModel {
        get {
            return self.cellModel as! ItemCellModel
        }
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self.isFocused {
            self.focusedAnimation()
        } else {
            self.notFocusedAnimation()
        }
    }
    
    
    private func focusedAnimation() {
        
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = 0
            self.topConstraint.constant = 0
            self.leftConstraint.constant = 0
            self.rightConstraint.constant = 0
            
            self.layoutIfNeeded()
        }
    }
    
    
    private func notFocusedAnimation() {
        
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = 24
            self.topConstraint.constant = 24
            self.leftConstraint.constant = 40
            self.rightConstraint.constant = 40
            
            self.layoutIfNeeded()
        }
    }
}

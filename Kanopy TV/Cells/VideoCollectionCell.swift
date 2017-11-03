//
//  VideoCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

class VideoCollectionCell: GenericCollectionCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bgWidth: NSLayoutConstraint!
    @IBOutlet weak var bgHeight: NSLayoutConstraint!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.thumbImageView.sd_setImage(with: URL.init(string: (self.itemCM.item.images?.mediumThumbURL())!))
        self.titleLabel.text = self.itemCM.item.title
        
        self.update(false)
    }
    
    
    var itemCM: ItemCellModel {
        get {
            return self.cellModel as! ItemCellModel
        }
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        self.update(true)
    }
    
    
    private func update(_ isAnimated: Bool!) {
        if self.isFocused {
            self.focusedAnimation(isAnimated)
        } else {
            self.notFocusedAnimation(isAnimated)
        }
    }

    
    private func focusedAnimation(_ isAnimated: Bool!) {
        
        if !isAnimated {
            self.bgWidth.constant = self.itemCM.focusWidth
            self.bgHeight.constant = self.itemCM.focusHeight
            
            self.updateConstraintsIfNeeded()
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.bgWidth.constant = self.itemCM.focusWidth
            self.bgHeight.constant = self.itemCM.focusHeight
            
            self.layoutIfNeeded()
        }
    }
    
    
    private func notFocusedAnimation(_ isAnimated: Bool!) {
        
        if !isAnimated {
            self.bgWidth.constant = self.itemCM.width
            self.bgHeight.constant = self.itemCM.height
            
            self.updateConstraintsIfNeeded()
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.bgWidth.constant = self.itemCM.width
            self.bgHeight.constant = self.itemCM.height
            
            self.layoutIfNeeded()
        }
    }
}

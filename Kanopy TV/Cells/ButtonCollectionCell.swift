//
//  ButtonCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class ButtonCollectionCell: GenericCollectionCell {
    
    @IBOutlet weak var buttonBGView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthButtonConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.buttonBGView.layer.cornerRadius = 8.0
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.updateButton(false)
        
        self.titleLabel.text = self.buttonCM.title
        self.iconImageView.image = UIImage.init(named: self.buttonCM.iconName)
    }
    
    
    var buttonCM: ButtonCollectionCellModel {
        get {
            return self.cellModel as! ButtonCollectionCellModel
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
        self.topButtonConstraint.constant = 0
        self.buttonHeightConstraint.constant = 90
        self.widthButtonConstraint.constant = 157
        
        self.titleLabel.layer.opacity = 1.0
        
        self.buttonBGView.backgroundColor = UIColor.mainOrangeColor()
        
        self.layoutIfNeeded()
    }
    
    
    private func updateForNotFocus() {
        self.topButtonConstraint.constant = 5
        self.buttonHeightConstraint.constant = 85
        self.widthButtonConstraint.constant = 145
        
        
        self.titleLabel.layer.opacity = 0.6
        
        self.buttonBGView.backgroundColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        
        self.layoutIfNeeded()
    }
}

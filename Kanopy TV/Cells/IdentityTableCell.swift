//
//  IdentityTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

class IdentityTableCell: GenericCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var topBGConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightBGConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBGConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftBGConstrain: NSLayoutConstraint!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgView.layer.cornerRadius = 4.0
        self.statusView.layer.cornerRadius = 6.0
        
        self.updateFocus(animate: false)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.identityCM.identity.domainName
        self.statusView.backgroundColor = self.identityCM.statusColorValue
        
        self.updateFocus(animate: false)
    }
    
    
    // MARK: -
    
    
    var identityCM: IdentityCellModel {
        get {
            return self.cellModel as! IdentityCellModel
        }
    }
    
    
    // MARK: -
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        self.updateFocus(animate: true)
    }
    
    
    private func updateFocus(animate: Bool!) {
        if self.isFocused {
            self.focusedAnimation(animate: animate)
        } else {
            self.notFocusedAnimation(animate: animate)
        }
    }
    
    
    private func focusedAnimation(animate: Bool!) {
        
        if animate == false {
            self.bgView.backgroundColor = UIColor.mainOrangeColor()
            self.leftBGConstrain.constant = 0.0
            self.rightBGConstraint.constant = 0.0
            self.topBGConstraint.constant = 0.0
            self.bottomBGConstraint.constant = 0.0
            
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.bgView.backgroundColor = UIColor.mainOrangeColor()
            self.leftBGConstrain.constant = 0.0
            self.rightBGConstraint.constant = 0.0
            self.topBGConstraint.constant = 0.0
            self.bottomBGConstraint.constant = 0.0
            
            self.layoutIfNeeded()
        }
    }
    
    
    private func notFocusedAnimation(animate: Bool!) {
        
        if animate == false {
            
            self.bgView.backgroundColor = UIColor.init(red: 58/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1.0)
            
            self.leftBGConstrain.constant = 15.0
            self.rightBGConstraint.constant = 15.0
            self.topBGConstraint.constant = 2.0
            self.bottomBGConstraint.constant = 2.0
            
            return
        }
        
        
        UIView.animate(withDuration: 0.2) {
            
            self.bgView.backgroundColor = UIColor.init(red: 58/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1.0)
            
            self.leftBGConstrain.constant = 15.0
            self.rightBGConstraint.constant = 15.0
            self.topBGConstraint.constant = 2.0
            self.bottomBGConstraint.constant = 2.0
            
            self.layoutIfNeeded()
        }
    }
}

//
//  MembershipTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class MembershipTableCell: GenericCell {

    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.statusLabel.layer.cornerRadius = 4.0
        self.statusLabel.layer.borderWidth = 1.0
        self.pointView.layer.cornerRadius = 3.0
        self.statusLabel.clipsToBounds = true
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted == true {
            self.backgroundColor = UIColor.mainBackgroundDarkGreyColor()
            self.contentView.backgroundColor = UIColor.mainBackgroundDarkGreyColor()
        } else {
            self.backgroundColor = UIColor.clear
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.updateTextForLabels()
        self.updateLabelsDesign()
    }
    
    
    var identityCM: IdentityCellModel {
        get {
            return self.cellModel as! IdentityCellModel
        }
    }
    
    
    func updateTextForLabels() {
        self.titleLabel.text = self.identityCM.identity.domainName
        self.statusLabel.text = self.identityCM.identity.statusKey.capitalizingFirstLetter()
    }
    
    
    func updateLabelsDesign() {
        self.pointView.backgroundColor = self.identityCM.viewModel.statusColor
        self.statusLabel.textColor = self.identityCM.viewModel.statusTextColor
        self.statusLabel.layer.borderColor = self.identityCM.viewModel.statusColor.cgColor
        self.statusLabel.backgroundColor = self.identityCM.viewModel.activeViewBackground
        
        self.titleLabel.textColor = self.identityCM.viewModel.membershipTextColor
        self.titleLabel.layer.opacity = Float(self.identityCM.viewModel.membershipTextOpacity)
        self.titleLabel.font = self.identityCM.viewModel.font
    }
}

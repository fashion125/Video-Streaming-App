//
//  SocialTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class SocialTableCell: GenericCell {

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var googleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.googleButton.layer.cornerRadius = 1.0
        self.facebookButton.layer.cornerRadius = 1.0
        
        self.facebookButton.addSubview(self.facebookView)
        self.googleButton.addSubview(self.googleView)
        
        self.addNotificationForButtons(button: self.facebookButton)
        self.addNotificationForButtons(button: self.googleButton)
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
    }
    
    
    func addNotificationForButtons(button: UIButton!) {
        
        button.addTarget(self, action: #selector(SocialTableCell.hightLightValueButtonAction(button:)), for: UIControlEvents.touchDown)
        button.addTarget(self, action: #selector(SocialTableCell.normalValueAction(button:)), for: UIControlEvents.touchDragOutside)
        button.addTarget(self, action: #selector(SocialTableCell.normalValueAction(button:)), for: UIControlEvents.touchCancel)
        button.addTarget(self, action: #selector(SocialTableCell.normalValueAction(button:)), for: UIControlEvents.touchDragExit)
    }
    
    
    func hightLightValueButtonAction(button: UIButton!) {
        button.layer.opacity = 0.5
    }
    
    
    func normalValueAction(button: UIButton!) {
        button.layer.opacity = 1.0
    }
    
    
    func socialCM() -> SocialCellModel {
        return self.cellModel as! SocialCellModel
    }
    
    // MARK: - Actions
    
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        self.normalValueAction(button: self.facebookButton)
        self.socialCM().faceBookCommand.execute()
    }
    
    
    @IBAction func googleButtonAction(_ sender: Any) {
        self.normalValueAction(button: self.googleButton)
        self.socialCM().googleCommand.execute()
    }
    
}

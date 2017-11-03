//
//  UserMenuTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit
import SDWebImage
import MarqueeLabel

class UserMenuTableCell: GenericCell {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userActivationLabel: UILabel!
    @IBOutlet weak var pointerView: UIView!
    @IBOutlet weak var membershipValueLabel: MarqueeLabel!
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhotoImageView.layer.cornerRadius = 36.0
        self.pointerView.layer.cornerRadius = 3.0
        self.userPhotoImageView.clipsToBounds = true
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.fullNameLabel.text = self.userCM.user.username
        self.userActivationLabel.text = "MEMBERSHIP".localized
        
        self.updateMembershipValue()
        
        self.membershipValueLabel.marqueeType = .MLLeftRight
        self.membershipValueLabel.animationDelay = 2.0
        self.membershipValueLabel.rate = 20.0
        self.membershipValueLabel.fadeLength = 10.0
        self.membershipValueLabel.restart()
        
        self.updateStatusPointView()
        self.updateUserPhoto()
    }
    
    
    var userCM: UserCellModel {
        get {
            return self.cellModel as! UserCellModel
        }
    }
    
    
    // MARK: - Tools 
    
    
    private func updateMembershipValue() {
        if AuthService.sharedInstance.user != nil && AuthService.sharedInstance.user.currentIdentity != nil && (AuthService.sharedInstance.user.currentIdentity?.isNotNational())! {
            self.membershipValueLabel.text = AuthService.sharedInstance.user.currentIdentity?.domainName
        } else {
            self.membershipValueLabel.text = "NO_MEMBERSHIP".localized
        }
    }
    
    
    func updateUserPhoto() {
        self.userPhotoImageView.image = UIImage.init(named: "user_placeholder")
        self.userPhotoImageView.sd_setImage(with: URL.init(string: (self.userCM.user.avatar)!),
                                            completed: { (image: UIImage?, error: Error?, cache: SDImageCacheType, url: URL?) in
                                                if image != nil {
                                                    self.userPhotoImageView.image = image
                                                } else {
                                                    self.userPhotoImageView.image = UIImage.init(named: "user_placeholder")
                                                }
        })
    }
    
    
    func updateStatusPointView() {
        
        if ((AuthService.sharedInstance.user.currentIdentity?.isNotNational())!) {
            if self.userCM.user.currentIdentity?.statusKey == "active" {
                self.pointerView.backgroundColor = UIColor.membershipGreenColor()
            } else {
                self.pointerView.backgroundColor = UIColor.membershipRedColor()
            }
        } else {
            self.pointerView.backgroundColor = UIColor.white
        }
    }
}

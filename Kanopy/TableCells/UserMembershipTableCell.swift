//
//  UserMembershipTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 23.05.17.
//
//

import UIKit
import SDWebImage
import MarqueeLabel

class UserMembershipTableCell: GenericCell {

    
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var defaultMembershipLabel: UILabel!
    @IBOutlet weak var defaultMembershipValueLabel: MarqueeLabel!
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhotoImageView.layer.cornerRadius = 40.0
        self.userPhotoImageView.clipsToBounds = true
        self.pointView.layer.cornerRadius = 3.0
    }
    
    
    // MARK: -
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.updateLabels()
        self.updateUserImage()
        self.updateStatusPointView()
    }
    
    
    func updateLabels() {
        self.userFullNameLabel.text = self.userCM.user.username
        self.defaultMembershipLabel.text = "MEMBERSHIP".localized
        
        if (AuthService.sharedInstance.user.currentIdentity?.isNotNational())! {
            self.defaultMembershipValueLabel.text = AuthService.sharedInstance.user.currentIdentity?.domainName
        } else {
            self.defaultMembershipValueLabel.text = "NO_MEMBERSHIP".localized
        }
        
        self.defaultMembershipValueLabel.marqueeType = .MLLeftRight
        self.defaultMembershipValueLabel.animationDelay = 2.0
        self.defaultMembershipValueLabel.rate = 20.0
        self.defaultMembershipValueLabel.fadeLength = 10.0
        self.defaultMembershipValueLabel.restart()
    }
    
    
    func updateUserImage() {
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
        
        if (AuthService.sharedInstance.user.currentIdentity?.isNotNational())! {
            if self.userCM.user.currentIdentity?.statusKey == "active" {
                self.pointView.backgroundColor = UIColor.membershipGreenColor()
            } else {
                self.pointView.backgroundColor = UIColor.membershipRedColor()
            }
        } else {
            self.pointView.backgroundColor = UIColor.white
        }
    }
    
    
    // MARK: - Tools
    
    
    var userCM: UserCellModel {
        get {
            return self.cellModel as! UserCellModel
        }
    }
}

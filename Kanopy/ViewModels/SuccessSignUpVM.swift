//
//  SuccessSignUpVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit

class SuccessSignUpVM: ActivationVM {
    
    
    // MARK: - Init 
    
    
    override init(delegate: ActivationVCDelegate!) {
        super.init(delegate: delegate)
        
        self.genericSections()
    }
    
    
    func genericSections() {
        
        let bmcm = self.marginCellModel(0.0)
        
        var cellModels = [self.topTitleCellModel(),
                          self.marginCellModel(24.0),
                          self.nameCellModel(),
                          self.marginCellModel(24.0),
                          self.sentEmailCellModel(),
                          self.marginCellModel(24.0),
                          self.emailCellModel(),
                          self.marginCellModel(24.0),
                          self.descriptionCellModel(),
                          bmcm,
                          self.resentEmail()]
        
        let signOutCellModel = self.signOutCellModel()
        
        var totalHeight: CGFloat = 0
        
        for cm in cellModels {
            totalHeight = totalHeight + cm.height
        }
        
        totalHeight = totalHeight + signOutCellModel.height + 64
        
        var margin = (UIScreen.main.bounds.height - totalHeight)
        
        if margin < 0 {
            margin = 20
        }
        
        cellModels.insert(self.marginCellModel(margin*0.23), at: 0)
        cellModels.append(self.marginCellModel(margin*0.18))
        bmcm.updateHeight(margin*0.59)
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    func topTitleCellModel() -> TextCellModel {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Demi", size: 17.0)
        
        return self.attrCellModel("THANKS_SIGN_UP".localized,
                                  font!,
                                  UIColor.white,
                                  17.0)
    }
    
    
    func nameCellModel() -> TextCellModel {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 24.0)

        return self.attrCellModel((AuthService.sharedInstance.displayName()),
                                  font!,
                                  UIColor.mainOrangeColor(),
                                  40.0)
    }
    
    
    func sentEmailCellModel() -> TextCellModel {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 16.0)
        
        return self.attrCellModel("SENT_EMAIL_TEXT".localized,
                                  font!,
                                  UIColor.white,
                                  20.0)
    }
    
    
    func emailCellModel() -> TextCellModel {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Light", size: 20.0)

        return self.attrCellModel((AuthService.sharedInstance.user?.mail)!,
                                  font!,
                                  UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5),
                                  30.0)
    }
    
    
    func descriptionCellModel() -> TextCellModel {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 16.0)
        
        return self.attrCellModel("PLEASE_FOLLOW_LINK".localized,
                                  font!,
                                  UIColor.white,
                                  3.0 * (font?.lineHeight)! + (2 * (0.25 * (font?.lineHeight)!)))
    }
    
    
    func resentEmail() -> ButtonCellModel {
        
        let resendEmailCommand = ResendEmailCommand.init(delegate: self.delegate)
        
        return ButtonCellModel.init(title: "RESEND_EMAIL_TEXT".localized,
                                    font: UIFont.init(name: "AvenirNextLTPro-Medium", size: 14.0),
                                    color: UIColor.white,
                                    buttonCommand: resendEmailCommand,
                                    cellID: TableCellIDs.titleButtonTableCell,
                                    isUnderline: true,
                                    height: 40.0)
    }
    
    
    func signOutCellModel() -> ButtonCellModel {
        
        let signOutCommand = SignOutCommand.init(delegate: self.delegate)
        
        return ButtonCellModel.init(title: "SIGN_OUT".localized.uppercased(),
                                    font: UIFont.init(name: "AvenirNextLTPro-Regular", size: 10.0),
                                    color: UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75),
                                    buttonCommand: signOutCommand,
                                    cellID: TableCellIDs.titleButtonTableCell,
                                    isUnderline: false,
                                    height: 18.0)
    }
}

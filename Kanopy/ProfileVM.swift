//
//  ProfileVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class ProfileVM: GenericVM {
    
    private(set) var delegate: ProfileVCDelegate!
    private(set) var statusModel: StatusActivationModel!
    
    // MARK: - Init method 
    
    
    init(delegate: ProfileVCDelegate!, withStatusModel: StatusActivationModel) {
        super.init()
        
        self.delegate = delegate
        self.statusModel = withStatusModel
        
        self.generareSections()
    }
    
    
    func generareSections() {
        
        self.generateHeaderSection()
        
        self.generateIdentityesSection()
        
        if (!self.statusModel.isVerifyAccount) {
            self.generateContinueOnboardingSection()
        } else {
            self.generateAddMembershipSection()
        }
    }
    
    
    func generateHeaderSection() {
        
        let cellModels: Array<GenericCellModel> = [self.userCellModel(),
                                                   self.emailCellModel()]
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    func generateIdentityesSection() {
        
        var cellModels: Array<GenericCellModel> = [GenericCellModel]()
        var idnts = AuthService.sharedInstance.user?.identities
        
        if ((idnts?.count)! > 0) {
            cellModels.append(self.firstMembershipCellModel())
            
            idnts?.remove(at: 0)
            
            for id in idnts! {
                cellModels.append(self.membershipCellModel(id))
            }
            
            cellModels.append(GenericCellModel.init(TableCellIDs.emptyTableCell, height: 8.0))
            cellModels.append(GenericCellModel.init(TableCellIDs.separatorTableCell,
                                                    height: 1.0))
            
            self.sections.append(SectionModel.init(cellModels: cellModels))
        }
    }
    
    
    func generateAddMembershipSection() {
        
        var cellModels: Array<GenericCellModel> = [GenericCellModel]()
        
        cellModels.append(self.addMembershipCellModel())
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    func generateContinueOnboardingSection() {
        
        var cellModels: Array<GenericCellModel> = [GenericCellModel]()
        
        cellModels.append(self.continueOnboardingCellModel())
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    func firstMembershipCellModel() -> IdentityCellModel {
        
        let firstIdnt = AuthService.sharedInstance.user?.identities.first
        let isCurrent = AuthService.sharedInstance.user?.currentIdentity?.ID == firstIdnt?.ID
        
        var msVM: MembershipCellVM?  = nil
        
        if firstIdnt?.statusKey == "active" {
            msVM = MembershipCellVM.viewModelForActive(isCurrent)
        } else {
            msVM = MembershipCellVM.viewModelForNoActive(isCurrent)
        }
        
        let command = MembershipCommand.init(delegate: self.delegate)
        
        
        let cm = IdentityCellModel.init(identity: firstIdnt,
                                        cellID: TableCellIDs.membershipWithTitleTableCell,
                                        height: 62.0,
                                        title: "MEMBERSHIP".localized,
                                        command: command,
                                        viewModel: msVM)
        return cm
    }
    
    
    func membershipCellModel(_ identity: IdentityModel!) -> IdentityCellModel {
        
        let isCurrent = AuthService.sharedInstance.user?.currentIdentity?.ID == identity.ID
        var msVM: MembershipCellVM?  = nil
        
        if identity.statusKey == "active" {
            msVM = MembershipCellVM.viewModelForActive(isCurrent)
        } else {
            msVM = MembershipCellVM.viewModelForNoActive(isCurrent)
        }
        
        let command = MembershipCommand.init(delegate: self.delegate)
        
        let cm = IdentityCellModel.init(identity: identity,
                                        cellID: TableCellIDs.membershipTableCell,
                                        height: 44.0,
                                        title: "",
                                        command: command,
                                        viewModel: msVM)
        return cm
    }
    
    
    func userCellModel() -> UserCellModel {
        
        let userCellModel = UserCellModel.init(user: AuthService.sharedInstance.user, command: nil, cellID: TableCellIDs.userMembershipTableCell, height: 112.0)
        return userCellModel
    }
    
    
    func emailCellModel() -> InfoCellModel {
        
        let emailCellModel = InfoCellModel.init(title: "EMAIL".localized,
                                                value: AuthService.sharedInstance.user?.mail,
                                                cellID: TableCellIDs.profileInfoTableCell,
                                                height: 58.0)
        
        return emailCellModel
    }
    
    
    func addMembershipCellModel() -> ButtonCellModel {
        // Logging the user to add a memebership and if he add one then he will redirected to his memberships
        let destination = "user/" + (AuthService.sharedInstance.user?.userID)! + "/identities/add?destination=user/" + (AuthService.sharedInstance.user?.userID)! + "/identities/"
        let connectMembershipCommand = ConnectMembershipCommand.init(delegate: self.delegate!, destination: destination)
        
        let buttonCellModel = ButtonCellModel.init(title: "ADD_LIBRARY".localized,
                                                   font: UIFont.init(name: "AvenirNextLTPro-Medium", size: 16.0),
                                                   color: UIColor.white,
                                                   buttonCommand: connectMembershipCommand,
                                                   cellID: TableCellIDs.titleButtonTableCell,
                                                   isUnderline: false,
                                                   height: 58.0)
        
        return buttonCellModel
    }
    
    
    func continueOnboardingCellModel() -> ButtonCellModel {
        let continueOnboardingCommand = ContinueOnboardingCommand.init(delegate: self.delegate!)
        
        let buttonCellModel = ButtonCellModel.init(title: "CONTINUE_ONBOARDING".localized,
                                                   font: UIFont.init(name: "AvenirNextLTPro-Medium", size: 16.0),
                                                   color: UIColor.white,
                                                   buttonCommand: continueOnboardingCommand,
                                                   cellID: TableCellIDs.titleButtonTableCell,
                                                   isUnderline: false,
                                                   height: 58.0)
        
        return buttonCellModel
    }
}

//
//  MembershipListVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

class MembershipListVM: GenericVM {

    private(set) var delegate: MembershipListVCDelegate!
    
    // MARK: - Init method
    
    
    init(delegate: MembershipListVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        
        self.generateSections()
    }
    
    
    // MARK: - Tools 
    
    
    private func generateSections() {
        
        let identities: Array<IdentityModel> = AuthService.sharedInstance.user.identities
        var cellModels: Array<GenericCellModel> = [GenericCellModel]()
        
        for id in identities {
            let cmd = ChooseMembershipCommand.init(delegate: self.delegate)
            let cm = IdentityCellModel.init(identity: id, command: cmd)
            cellModels.append(cm)
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
}

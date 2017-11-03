//
//  MembershipScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

protocol MembershipScenarioDelegate {
    
    /** This method is call when user choosed new membership */
    func didChoosedNewMembership(membershipScenario: MembershipScenario!)
}


class MembershipScenario: Scenario, MembershipInfoVCDelegate, MembershipListVCDelegate {

    private(set) var rootVC: GenericVC!
    private(set) var delegate: MembershipScenarioDelegate!
    private(set) var membershipInfoVC: MembershipInfoVC!
    private(set) var membershipListVC: MembershipListVC!
    
    
    // MARK: - Init methods 
    
    
    init(rootVC: GenericVC!, delegate: MembershipScenarioDelegate!) {
        super.init()
        
        self.rootVC = rootVC
        self.delegate = delegate
    }
    
    
    // MARK: -
    
    
    override func start() {
        self.showMembershipInfoVC()
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: - Tools 
    
    
    private func showMembershipInfoVC() {
        
        if (AuthService.sharedInstance.user.identities.count > 0) {
            let vm = MembershipInfoVM.init(delegate: self)
            self.membershipInfoVC = MembershipInfoVC.init(delegate: self, viewModel: vm)
            self.rootVC.present(self.membershipInfoVC, animated: true, completion: nil)
        } else {
            
            let message = "You don't have any library memberships linked to your account yet. To add a new membership please visit:\nkanopy.com"
            UIAlertController.showAlertWithButtons(title: "", message: message, fromVC: self.rootVC, firstButtonTitle: "Back".localized, secondButtonTitle: "", trueButton: {
                
            }, falseButton: { 
                
            })
        }
    }
    
    
    private func showMembershipListVC() {
        self.membershipListVC = MembershipListVC.init(delegate: self)
        self.membershipInfoVC.present(self.membershipListVC, animated: true, completion: nil)
        
        self.membershipListVC.showLoadIndicator()
        
        AuthService.sharedInstance.getMeUser(completion: { (user: UserModel) in
            
            let vm = MembershipListVM.init(delegate: self)
            self.membershipListVC.updatViewModel(viewModel: vm)
            self.membershipListVC.hideLoadIndicator()
            
        }, cacheCompletion: { (user: UserModel) in
            
        }) { (error: ErrorModel) in
            self.membershipListVC.hideLoadIndicator()
            UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.membershipListVC)
        }
    }
    
    
    // MARK: - MembershipInfoVCDelegate methods 
    
    
    func didPressSelectMembershipButton(membershipInfoVC: MembershipInfoVC!) {
        self.showMembershipListVC()
    }
    
    
    func didPressBackButton(membershipInfoVC: MembershipInfoVC!) {
        self.membershipInfoVC.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - MembershipListVCDelegate method 
    
    
    func didChooseIdentity(identity: IdentityModel!) {
        
        let loadVC = LoadVC()
        self.membershipListVC.present(loadVC, animated: true, completion: nil)
        
        AuthService.sharedInstance.switchMembership(identity: identity,
                                                    completion: { (token: String) in
                                                        self.membershipListVC.dismiss(animated: true, completion: nil)
                                                        self.delegate.didChoosedNewMembership(membershipScenario: self)
        }) { (error: ErrorModel) in
            
            self.membershipListVC.dismiss(animated: true, completion: nil)
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.membershipListVC!)
        }
    }
}

//
//  ProfileScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 21.06.17.
//
//

import UIKit
import MBProgressHUD


protocol ProfileScenarioDelegate {
    /** This method is call when user choose membership */
    func didShowHomePageScreen(_ profileScenario: ProfileScenario!)
}


class ProfileScenario: Scenario, ProfileVCDelegate, ActivationScenarioDelegate, WKWebViewVCDelegate {
    var nvc: MenuNavigationController!
    var profileVC: ProfileVC?
    
    var activationScenario: ActivationScenario!
    
    private(set) var loadingNotification: MBProgressHUD? = nil
    private(set) var delegate: ProfileScenarioDelegate!
    
    
    // MARK: - Init methods 
    
    
    init(nvc: MenuNavigationController!, delegate: ProfileScenarioDelegate!) {
        super.init()
        
        self.nvc = nvc
        self.delegate = delegate
    }
    
    
    // MARK: - Override methods
    
    
    override func start() {
        self.showUserProfileVC()
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: - Tools 
    
    
    func showUserProfileVC() {
        
        self.profileVC = ProfileVC.init(delegate: self)
        self.nvc.pushViewController(self.profileVC!, animated: true)

        self.profileVC?.showLoadIndicator()
        self.loadDataForUserProfileVC()
    }
    
    
    func loadDataForUserProfileVC() {
        self.updateUserViewModel()
        
        AuthService.sharedInstance.getMeUser(completion: { (user: UserModel) in
            
            self.profileVC?.hideLoadIndicator()
            self.updateUserViewModel()
            RefreshService.sharedInstance.notifyAboutRefreshSideMenu()
            
        }, cacheCompletion: { (user: UserModel) in
            
            self.profileVC?.hideLoadIndicator()
            self.updateUserViewModel()
            
        }) { (error: ErrorModel) in
            self.profileVC?.hideLoadIndicator()
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.profileVC!)
        }
    }
    
    
    func updateUserViewModel() {
        
        let statusModel = AuthService.sharedInstance.statusModel
        let profileVM = ProfileVM.init(delegate: self, withStatusModel: statusModel!)
        self.profileVC?.update(with: profileVM)
    }
    
    
    private func startActivationScenario(withStatusModel: StatusActivationModel) {
        
        self.activationScenario = ActivationScenario.init(authVC: (self.profileVC),
                                                          delegate: self, comingFromLoginScenario: false)
        self.activationScenario.start(withStatusModel: withStatusModel)
    }
    
    
    // MARK: - ProfileVCDelegate method
    
    
    func didChooseMembership(identity: IdentityModel!) {
        let statusModel = AuthService.sharedInstance.statusModel
        
        if (statusModel?.isVerifyAccount)! {
            let userID = AuthService.sharedInstance.user?.userID
            let destination = "user/" + userID! + "/identities"
            
            if identity.statusKey == "blocked" || identity.statusKey == "inactive" || identity.statusKey == "expired" {
                // Logging the user to his memberships list and auto click on the button with id "button-"+domainStem
                // Hashtag corresponding to operation:group:name
                self.autologinTo(destination: destination, hashtag: "click:id:button-"+identity.domainStem)
                return
            }
            
            self.loadingNotification = MBProgressHUD.showAdded(to: (self.profileVC?.view)!, animated: true)
            self.loadingNotification?.mode = MBProgressHUDMode.indeterminate
            
            AuthService.sharedInstance.switchMembership(identity: identity,
                                                        completion: { (token: String) in
                                                            self.loadingNotification?.hide(animated: true)
                                                            self.delegate.didShowHomePageScreen(self)
            }) { (error: ErrorModel) in
                self.loadingNotification?.hide(animated: true)
                UIAlertController.showAlert(title: error.titleError,
                                            message: error.messageError!,
                                            fromVC: self.profileVC!)
            }
        } else {
            self.startActivationScenario(withStatusModel: statusModel!)
        }
    }
    
    
    func willEnterBackground(profileVC: ProfileVC!) {
        self.loadDataForUserProfileVC()
    }
    
    
    func autologinTo(destination: String, hashtag: String) {
        self.loadingNotification = MBProgressHUD.showAdded(to: (self.profileVC?.view)!, animated: true)
        self.loadingNotification?.mode = MBProgressHUDMode.indeterminate
        
        let userID = AuthService.sharedInstance.user?.userID
        
        _ = AuthService.sharedInstance.getAutologinUrl(userID: userID, destination: destination, hashtag: hashtag,
                                                       completion: { (url: String) in
                                                        self.loadingNotification?.hide(animated: true)
                                                        let wkWebViewVC = WKWebViewVC.init(delegate: self, url: url)
                                                        self.profileVC?.navigationController?.pushViewController(wkWebViewVC, animated: true)
        }, failure: { (error: ErrorModel) in
            self.loadingNotification?.hide(animated: true)
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.profileVC!)
            // We don't show anything for the moment
        })
    }
    
    
    func continueOnboarding() {
        let statusModel = AuthService.sharedInstance.statusModel
        
        self.startActivationScenario(withStatusModel: statusModel!)
    }
    
    
    func didPressToBackButton(profileVC: ProfileVC!) {
        self.nvc.popViewController(animated: true)
    }
    
    
    // MARK: - WKWebViewVCDelegate method
    
    
    /** This method is called when user tap to back button */
    func didPressBackButton(wkWebViewVC: WKWebViewVC!) {
        self.profileVC?.navigationController?.popViewController(animated: true)
        self.loadDataForUserProfileVC()
    }
    
    
    /** This method is called when the webview has totally disappeared */
    func webviewDidDisappear(wkWebViewVC: WKWebViewVC!) {
        
    }
    
    
    // MARK: - ActivationScenarioDelegate methods
    
    
    func successfullActivation(_ scenario: ActivationScenario!) {
        self.loadDataForUserProfileVC()
        scenario.stop()
    }
    
    
    func stopScenario(scenario: ActivationScenario!) {
    }
    
    
    func didPressToBackButton(scenario: ActivationScenario!) {
        self.loadDataForUserProfileVC()
        scenario.activationVC.navigationController?.popViewController(animated: true)
    }
    
    
    func didPressToSignOutButton(scenario: ActivationScenario!) {
    }
}

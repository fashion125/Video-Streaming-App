//
//  ActivationScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit
import MBProgressHUD

protocol ActivationScenarioDelegate {
    
    func stopScenario(scenario: ActivationScenario!)
    
    func successfullActivation(_ scenario: ActivationScenario!)
    
    func didPressToBackButton(scenario: ActivationScenario!)
    
    func didPressToSignOutButton(scenario: ActivationScenario!)
}

class ActivationScenario: Scenario, ActivationVCDelegate, SearchInstitutionScenarioDelegate {

    var delegate: ActivationScenarioDelegate!
    private(set) var authVC: GenericVC!
    private(set) var activationVC: ActivationVC!
    private(set) var genericSearchVC: GenericSearchVC!
    private(set) var searchInstitutionScenario: SearchInstitutionScenario!
    private(set) var hasStopped = false
    private(set) var webViewOpened = false
    private(set) var canRefresh = true
    
    private(set) var timer: Timer!
    private(set) var isCanTimer: Bool! = true
    
    private(set) var statusModel: StatusActivationModel!
    
    private(set) var currentActivationStepKey: String! = ""
    
    let pollEachNumberOfSeconds = 5
    let maxMinutesPollingTime = 30
    private(set) var date = Date()
    
    private(set) var loadingNotification: MBProgressHUD? = nil
    
    var comingFromLoginScenario: Bool!
    
    // MARK: - Init method 
    
    
    init(authVC: GenericVC!, delegate: ActivationScenarioDelegate!, comingFromLoginScenario: Bool!) {
        super.init()
        
        self.comingFromLoginScenario = comingFromLoginScenario
        
        self.delegate = delegate
        self.authVC = authVC
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
    }
    
    
    func rotated() {
        if statusModel.isAddMembership {
            if (!self.statusModel.isVerifyEmail || (self.statusModel.isAddMembership && self.statusModel.isMembershipStatusLookup)) {
                let statusVM = StatusVM.init(statusModel: statusModel, delegate: self)
                self.activationVC.update(with: statusVM)
                
                if (self.webViewOpened) {
                    self.activationVC.removeWebView()
                    self.webViewOpened = false
                }
            }
        } else if !statusModel.isVerifyEmail {
            self.updateForSuccessRegistration(statusModel: statusModel)
        }
    }
    
    
    // MARK: -
    
    
    /** Start the current scenario. */
    override func start() {
        self.showActivationVC()
    }
    
    /** Stop the current scenario. */
    override func stop() {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
        self.hasStopped = true
        self.activationVC.navigationController?.popViewController(animated: true)
        self.delegate?.stopScenario(scenario: self)
    }
    
    
    func start(withStatusModel statusModel: StatusActivationModel!) {
        self.date = Date()
        self.activationVC = ActivationVC.init(delegate: self)
        
        self.loadingNotification = MBProgressHUD.showAdded(to: (self.activationVC?.tableView)!, animated: true)
        self.loadingNotification?.mode = MBProgressHUDMode.indeterminate
        
        self.updateActivationVC(statusModel: statusModel)
        self.authVC.navigationController?.pushViewController(self.activationVC,
                                                            animated: true)
    }
    
    
    func showActivationVC() {
        self.activationVC = ActivationVC.init(delegate: self)
        
        self.loadingNotification = MBProgressHUD.showAdded(to: (self.activationVC?.tableView)!, animated: true)
        self.loadingNotification?.mode = MBProgressHUDMode.indeterminate
        
        self.updateForSuccessRegistration(statusModel: statusModel)
        
        self.authVC.navigationController?.pushViewController(self.activationVC,
                                                             animated: true)
        
        self.checkStatus()
    }
    
    
    func updateActivationVC(statusModel: StatusActivationModel!) {
        self.statusModel = statusModel
        
        if (canRefresh) {
            if statusModel.isAddMembership  {
                self.switchActiveMembership(statusModel)
            } else if !statusModel.isVerifyEmail {
                self.updateForSuccessRegistration(statusModel: statusModel)
                self.startTimer()
            }  else {
                if (self.comingFromLoginScenario) {
                    self.delegate.successfullActivation(self)
                } else {
                    self.updateForStatusVerification(statusModel: statusModel)
                    self.startTimer()
                }
            }
        } else {
            self.startTimer()
        }
    }
    
    
    func switchActiveMembership(_ statusModel: StatusActivationModel!) {
        AuthService.sharedInstance.getMeUser(completion: { (user: UserModel) in
            var firstActiveIdentity: IdentityModel = user.identities.first!
            
            user.identities.forEach({ (identityModel: IdentityModel) in
                if (firstActiveIdentity.statusKey != "active" && identityModel.statusKey == "active") {
                    firstActiveIdentity = identityModel
                }
            })
            
            AuthService.sharedInstance.switchMembership(identity: firstActiveIdentity,
                                                        completion: { (token: String) in
                                                            self.updateForStatusVerification(statusModel: statusModel, withUser: user)
                                                            if (!(statusModel.isVerifyEmail && statusModel.isAddMembership && statusModel.isMembershipStatusLookup)) {
                                                                self.startTimer()
                                                            }
            }, failure: { (error: ErrorModel) in
                self.startTimer()
            })
        }, cacheCompletion: { (user: UserModel) in
            
        }) { (error: ErrorModel) in
            self.startTimer()
        }
    }
    
    
    func switchInactiveMembership() {
        
        if AuthService.sharedInstance.user != nil && AuthService.sharedInstance.user.identities.count > 0 {
            AuthService.sharedInstance.switchMembership(identity: AuthService.sharedInstance.user.identities.first,
                                                        completion: { (token: String) in
            }, failure: { (error: ErrorModel) in
            })
        }
    }
    
    
    func updateForSuccessRegistration(statusModel: StatusActivationModel!) {
        self.loadingNotification?.hide(animated: true)
        
        let activationVM = SuccessSignUpVM.init(delegate: self)
        self.activationVC.update(with: activationVM)
    }
    
    
    func updateForStatusVerification(statusModel: StatusActivationModel!) {
        AuthService.sharedInstance.getMeUser(completion: { (user: UserModel) in
            self.updateForStatusVerification(statusModel: statusModel, withUser: user)
        }, cacheCompletion: { (user: UserModel) in
            
        }) { (error: ErrorModel) in
            
        }
    }
    
    
    func updateForStatusVerification(statusModel: StatusActivationModel!, withUser: UserModel) {
        self.loadingNotification?.hide(animated: true)
        
        if ((!self.statusModel.isVerifyEmail && self.currentActivationStepKey != CurrentActivationStepKeys.emailVerificationStep) || ((self.statusModel.isAddMembership && self.statusModel.isMembershipStatusLookup) && (self.currentActivationStepKey != CurrentActivationStepKeys.startWatchingStep))) {
            
            let statusVM = StatusVM.init(statusModel: statusModel, delegate: self)
            self.activationVC.update(with: statusVM)
            
            self.currentActivationStepKey = CurrentActivationStepKeys.emailVerificationStep
            
            if (self.webViewOpened) {
                self.activationVC.removeWebView()
                self.webViewOpened = false
            }
            
        } else if ((self.statusModel.isAddMembership && (withUser.identities.count) > 0) || (self.statusModel.isVerifyEmail)) {
            
            var destination = ""
            let hashtag = ""
            var currentActivationStep = self.currentActivationStepKey
            let userID = AuthService.sharedInstance.user?.userID
            
            if self.statusModel.isAddMembership && (withUser.identities.count) > 0 {
                destination = "wayf/user/welcome"
                
                if (AuthService.sharedInstance.user.currentIdentity?.isNational())! {
                    self.switchInactiveMembership()
                }
                
                currentActivationStep = CurrentActivationStepKeys.connectMembershipStep
                
            } else {
                
                destination = "wayf/user/welcome"
                currentActivationStep = CurrentActivationStepKeys.addYourLibrayStep
                
            }
            
            if (currentActivationStep != self.currentActivationStepKey && !(self.currentActivationStepKey == CurrentActivationStepKeys.addYourLibrayStep && currentActivationStep == CurrentActivationStepKeys.connectMembershipStep)) {
                
                _ = AuthService.sharedInstance.getAutologinUrl(userID: userID, destination: destination, hashtag: hashtag,
                                                               completion: { (url: String) in
                                                                self.activationVC.openWebViewWithUrl(url: url)
                                                                self.webViewOpened = true
                }, failure: { (error: ErrorModel) in
                    // We don't show anything for the moment
                })
                
            }
            
            self.currentActivationStepKey = currentActivationStep
            
            if (!self.webViewOpened) {
                let statusVM = StatusVM.init(statusModel: statusModel, delegate: self)
                self.activationVC.update(with: statusVM)
                
                self.activationVC.loadingNotification = MBProgressHUD.showAdded(to: (self.activationVC.tableView)!, animated: true)
                self.activationVC.loadingNotification?.mode = MBProgressHUDMode.indeterminate
            }
        }
    }
    
    
    func updateForSuccessActivation() {
        
        let successActivationVM = SuccessActivationVM.init(delegate: self)
        self.activationVC.update(with: successActivationVM)
    }
    
    
    func checkStatus() {
        AuthService.sharedInstance.checkStatusVerification(userID: AuthService.sharedInstance.user?.userID,
                                                           completion: { (statusModel: StatusActivationModel) in
                                                            self.loadingNotification?.hide(animated: true)
                                                            
                                                            self.updateActivationVC(statusModel: statusModel)
                                                            
        }) { (error: ErrorModel) in
            self.startTimer()
        }
    }
    
    
    func autologinTo(destination: String, hashtag: String) {
        let userID = AuthService.sharedInstance.user?.userID
        
        _ = AuthService.sharedInstance.getAutologinUrl(userID: userID, destination: destination, hashtag: hashtag,
                                                       completion: { (url: String) in
                                                        if #available(iOS 10.0, *) {
                                                            UIApplication.shared.open(NSURL(string: url)! as URL)
                                                        } else {
                                                            UIApplication.shared.openURL(URL(string: url)!)                                                                  }
        }, failure: { (error: ErrorModel) in
            // We don't show anything for the moment
        })
    }
    
    
    // MARK: - Timer
    
    
    func startTimer() {
        // Checking if the timer can be reset
        if self.isCanTimer && (-(self.date.timeIntervalSinceNow)).isLess(than: Double(self.maxMinutesPollingTime*60)) {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.pollEachNumberOfSeconds), target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        }
    }
    
    
    func stopTimer() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    
    func update() {
        self.checkStatus()
    }
    
    
    // MARK: - ActivationVC Delegate methods 
    
    
    /** This method is call when user tap to exit button */
    func exit() {
        RefreshService.sharedInstance.notifyAboutRefreshSideMenu()
        self.isCanTimer = false
        self.stopTimer()
        self.delegate.successfullActivation(self)
    }
    
    
    /** This method is call when user tap to resend email button */
    func resendEmail() {
        AuthService.sharedInstance.resendEmail(userID: AuthService.sharedInstance.user?.userID,
                                               completion: {
                                                UIAlertController.showAlert(title: "SUCCESSFUL".localized,
                                                                            message: "Email resent!",
                                                                            fromVC: self.activationVC)
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.activationVC)
        }
    }
    
    
    /** This method is call when user tap on Add your library or Connect membership button */
    func showSearchInstitution() {
        self.genericSearchVC = GenericSearchVC.init(placeholder: "SEARCH_INSTITUTION_TITLE".localized, width: (self.authVC.navigationController?.navigationBar.bounds.width)!, heigth: (self.authVC.navigationController?.navigationBar.bounds.height)!)
        self.genericSearchVC.navigationItem.hidesBackButton = true;
        self.searchInstitutionScenario = SearchInstitutionScenario.init(searchVC: self.genericSearchVC, delegate: self)
        self.searchInstitutionScenario.start()
        self.authVC.navigationController?.pushViewController(self.genericSearchVC, animated: true)
    }
    
    
    /** This method is call when user tap to sign out button */
    func signOut() {
        self.isCanTimer = false
        self.stopTimer()
        self.delegate.didPressToSignOutButton(scenario: self)
    }
    
    
    /** This method is call when user tap to back button */
    func didPressToBackButton() {
        self.isCanTimer = false
        self.stopTimer()
        RefreshService.sharedInstance.notifyAboutRefreshSideMenu()
        self.delegate.didPressToBackButton(scenario: self)
    }
    
    
    /** This method is call when a first popup is opened */
    func blockRefreshing() {
        self.canRefresh = false
    }
    
    
    /** This method is call when the first opened popup is closed */
    func unblockRefreshing() {
        self.canRefresh = true
    }
    
    
    // MARK: - SearchInstitutionScenario Delegate methods
    
    
    /** Method is call when user tap to 'Cancel' button and stop search */
    func didStopSearchInstitutionScenario(searchInstitutionScenario: SearchInstitutionScenario, searchVC: GenericSearchVC!) {
        self.authVC.navigationController?.popViewController(animated: true)
    }
    
    
    /** Method is call when user choose item on the result list */
    func didChooseItem(item: ItemModel!, searchInstitutionScenario: SearchInstitutionScenario!) {
    }
}

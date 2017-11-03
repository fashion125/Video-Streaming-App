//
//  MainScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit
import Foundation
import GoogleCast

class MainScenario: Scenario, LoginScenarioDelegate, RequestServiceDelegate, HomeScenarioDelegate, ActivationScenarioDelegate, FirstStartVCDelegate, GCKUIImagePicker {
    
    open private(set) var window: UIWindow!
    open private(set) var nvc: MenuNavigationController!
    
    var homeScenario: HomeScenario?
    var activationScenario: ActivationScenario!
    var firstStartVC: FirstStartVC?
    
    var justStarted: Bool! = true
    
    
    // MARK: - Init method
    
    
    init(window: UIWindow!) {
        super.init()
        self.window = window
        
        GCKCastContext.sharedInstance().imagePicker = self
    }
    
    
    // MARK: - Override Start/Stop methods 
    
    
    override func start() {
        
        RequestService.sharedInstance.addObserver(observer: self)
        
        if !SettingsService.sharedInstance.isFirstStartApp() {
            SettingsService.sharedInstance.firstStartIsCompleted()
            SettingsService.sharedInstance.updateCellularDataUsage(true)
            SettingsService.sharedInstance.updateClosedCaptions(false)
            self.startFirstStartScenario()
        } else {
            self.makeNavigationController()
            self.startHomeScenario()
            self.getSessionToken()
        }
    }
    
    
    override func stop() {
        RequestService.sharedInstance.removeObserver(observer: self)
    }
    
    
    // MARK: - Tools
    
    
    func getSessionToken() {
        AuthService.sharedInstance.getSessionToken(completion: {
            
            if (AuthService.sharedInstance.user.currentIdentity != nil && (AuthService.sharedInstance.user.currentIdentity?.isNational())! && AuthService.sharedInstance.user.identities.count > 0) {
                self.switchOtherMembership()
            } else {
                self.checkUser()
            }
        }) { (error: ErrorModel) in
            
            if error.statusCode == 401 {
                AuthService.sharedInstance.unauthorized()
                self.startLoginScenario(logIn: true)
            } else {
                
                self.homeScenario?.homeVC?.hideLoadIndicator()
                self.homeScenario?.menuVC?.hideLoadIndicator()
                
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.nvc)
            }
        }
    }
    
    
    private func switchOtherMembership() {
        AuthService.sharedInstance.switchMembership(identity: AuthService.sharedInstance.user.identities.first,
                                                    completion: { (token: String) in
                                                        self.checkUser()
        }, failure: { (error: ErrorModel) in
            self.switchOtherMembership()
        })
    }
    
    
    /** Method check user is authorized */
    func checkUser() {
        
        self.homeScenario?.loadHomePage()
        
        let userID = AuthService.sharedInstance.userID
        
        AuthService.sharedInstance.checkStatusVerification(userID: userID!,
                                            completion: { (statusModel: StatusActivationModel) in
                                                
                                                if !statusModel.isVerifyAccount {
                                                    self.startActivationScenario(withStatusModel: statusModel)
                                                }
        }) { (error: ErrorModel) in
        }
    }
    
    
    private func startActivationScenario(withStatusModel: StatusActivationModel) {
        
        self.activationScenario = ActivationScenario.init(authVC: (self.homeScenario?.homeVC)!,
                                                          delegate: self, comingFromLoginScenario: false)
        self.activationScenario.start(withStatusModel: withStatusModel)
    }
    
    
    /** Method create MenuNavigationController and update rootViewController */
    func makeNavigationController() {
        
        self.nvc = MenuNavigationController.init()
        let castContainerVC = GCKCastContext.sharedInstance().createCastContainerController(for: self.nvc)
        castContainerVC.miniMediaControlsItemEnabled = true;
        self.window?.rootViewController = castContainerVC;
    }

    
    // MARK: -
    
    
    /** Method start home scenario */
    func startHomeScenario() {
        self.homeScenario = HomeScenario.init(nvc: self.nvc)
        self.homeScenario?.delegate = self
        self.homeScenario?.start()
    }
    
    
    /** Method start first start scenario */
    func startFirstStartScenario() {
        self.firstStartVC = FirstStartVC(firstStartVCDelegate: self)
        self.window?.rootViewController = self.firstStartVC
    }
    
    
    /** Method start login scenario */
    func startLoginScenario(logIn: Bool!) {
        let loginScenario = LoginScenario.init(nvc: self.nvc, delegate: self)
        loginScenario.start(logIn: logIn)
    }
    
    
    // MARK: - LoginScenarioDelegate methods 
    
    
    func stopScenario(_ loginScenario: LoginScenario!) {
        self.startHomeScenario()
        self.checkUser()
    }
    
    
    func closeScenario(_ loginScenario: LoginScenario!) {
        self.getSessionToken()
    }
    
    
    // MARK: - ActivateScenarioDelegate methods 
    
    
    func stopScenario(scenario: ActivationScenario!) {
        
    }
    
    
    func successfullActivation(_ scenario: ActivationScenario!) {
        if (self.homeScenario != nil) {
            self.homeScenario?.loadHomePage()
        }
        
        scenario.stop()
    }
    
    
    func didPressToSignOutButton(scenario: ActivationScenario!) {
        AuthService.sharedInstance.unauthorized()
        self.homeScenario?.homeVC?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func didPressToBackButton(scenario: ActivationScenario!) {
        if (self.homeScenario != nil) {
            self.homeScenario?.loadHomePage()
        }
        
        scenario.activationVC.navigationController?.popViewController(animated: true)
        self.homeScenario?.homeVC?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - RequestServiceDelegate
    
    
    func notifyAboutUnauthorization(requestService: RequestService!) {
        
        OrientationService.sharedInstance.changeToPortraitOrientation()
        
        AuthService.sharedInstance.unauthorized()
        self.nvc.dismiss(animated: true, completion: nil)
        self.startLoginScenario(logIn: true)
    }
    
    
    // MARK: - HomeScenarioDelegate
    
    
    func didSignOut() {
        self.startHomeScenario()
        self.getSessionToken()
    }
    
    
    func didChangeMembership() {
        self.start()
    }
    
    
    
    // MARK: - FirstStartVCDelegate
    
    
    func didClickSignUp() {
        self.makeNavigationController()
        self.startHomeScenario()
        self.startLoginScenario(logIn: false)
    }
    
    
    func didClickLogIn() {
        self.makeNavigationController()
        self.startHomeScenario()
        self.startLoginScenario(logIn: true)
    }
    
    
    func didClickBrowseAsGuest() {
        self.makeNavigationController()
        self.startHomeScenario()
        self.getSessionToken()
    }
    
    
    // MARK: - GCKUIImagePicker Implementations
    
    
    /**
     * Returns an image of the specified type from the media metadata.
     *
     * @param imageHints The hints about how to pick the image.
     * @param metadata The media metadata to pick from.
     * @return The selected image, or <code>nil</code> if there is no appropriate image for the
     * requested type.
     */
    public func getImageWith(_ imageHints: GCKUIImageHints, from metadata: GCKMediaMetadata) -> GCKImage? {
        if (imageHints.imageType == .background || metadata.images().count == 0) {
            // Displaying a vertical image for the backgroud of the expanded controller because horizontal images are not rendering good
            return GCKImage.init(url: URL.init(string: "http://www.kanopystreaming.com/chromecast/assets/casting_to_tv.png")!, width: 480, height: 360)
        }
        
        return metadata.images()[0] as! GCKImage
    }
}

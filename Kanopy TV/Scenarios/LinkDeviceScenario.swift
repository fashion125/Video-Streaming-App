//
//  LinkDeviceScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

protocol LinkDeviceScenarioDelegate {
    
    /** This method is call when user tap to watch now button*/
    func didPressWatchNowButton(scenario: LinkDeviceScenario!)
}

class LinkDeviceScenario: Scenario, LinkDeviceVCDelegate {

    private(set) var rootVC: GenericVC!
    private(set) var delegate: LinkDeviceScenarioDelegate!
    private(set) var linkDevice: LinkDeviceVC!
    private(set) var timer: Timer!
    private(set) var authCode: String!
    
    
    // MARK: - Init methods 
    
    
    init(rootVC: GenericVC!, delegate: LinkDeviceScenarioDelegate!) {
        super.init()
        
        self.rootVC = rootVC
        self.delegate = delegate
    }
    
    
    // MARK: -
    
    
    override func start() {
        self.showLinkDeviceScreen()
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: -
    
    
    private func showLinkDeviceScreen() {
        let vm = LinkDeviceVM.init(iconImage: "enter_monitor_icon",
                                   title: "To link your Apple TV device to your\nKanopy account:",
                                   descriptionText: "1. Go to Kanopy.com/link\n2. Enter the code",
                                   buttonTitle: "GENERATE_NEW_CODE".localized,
                                   command: self.generateNewCodeCommand(),
                                   authCode: nil,
                                   buttonIsEnabled: false)
        
        self.linkDevice = LinkDeviceVC.init(delegate: self, vm: vm)
        self.rootVC.navigationController?.pushViewController(self.linkDevice, animated: true)
    }
    
    
    // MARK: - Update interface methods
    
    
    private func updateInterfaceForDefault(buttonIsEnabled: Bool!) {
        
        let vm = LinkDeviceVM.init(iconImage: "enter_monitor_icon",
                                   title: "To link your Apple TV device to your\nKanopy account:",
                                   descriptionText: "1. Go to Kanopy.com/link\n2. Enter the code",
                                   buttonTitle: "GENERATE_NEW_CODE".localized,
                                   command: self.generateNewCodeCommand(),
                                   authCode: nil,
                                   buttonIsEnabled: buttonIsEnabled)
        self.linkDevice.update(vm: vm)
    }
    
    
    private func updateInterfaceWithAuthCode(buttonIsEnabled: Bool!) {
        
        let vm = LinkDeviceVM.init(iconImage: "enter_monitor_icon",
                                   title: "To link your Apple TV device to your\nKanopy account:",
                                   descriptionText: "1. Go to Kanopy.com/link\n2. Enter the code",
                                   buttonTitle: "GENERATE_NEW_CODE".localized,
                                   command: self.generateNewCodeCommand(),
                                   authCode: self.authCode,
                                   buttonIsEnabled: buttonIsEnabled)
        self.linkDevice.update(vm: vm)
        self.startTimer()
    }
    
    
    private func updateInterfaceForSuccessfulDeviceBinding(userName: String!) {
        
        let vm = LinkDeviceVM.init(iconImage: "success_monitor_icon",
                                   title: "Welcome " + userName + "!",
                                   descriptionText: "Your kanopy account has been successfully linked to this Apple TV device.",
                                   buttonTitle: "Watch Now".localized,
                                   command: self.watchNowCommand(),
                                   authCode: nil,
                                   buttonIsEnabled: true)
        self.linkDevice.update(vm: vm)
    }
    
    
    // MARK: - Tools 
    
    
    // MARK: - LinkDeviceVCDelegate methods
    
    
    func didPressGetCodeButton() {
        
        self.loadAuthCode()
    }
    
    
    func didPressWatchNow() {
        self.rootVC.navigationController?.popViewController(animated: true)
        self.delegate.didPressWatchNowButton(scenario: self)
    }
    
    
    func willShow(_ linkDeviceVC: LinkDeviceVC!) {
        self.loadAuthCode()
    }
    
    
    func didHide(_ linkDeviceVC: LinkDeviceVC!) {
        self.updateInterfaceForDefault(buttonIsEnabled: false)
    }
    
    
    // MARK: - Timer
    
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
    }
    
    
    func stopTimer() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    
    func update() {
        
        AuthService.sharedInstance.authCodeVerification(authCode: self.authCode,
                                                        activated: { (token: String, user: UserModel) in
                                                            
                                                            self.updateInterfaceForSuccessfulDeviceBinding(userName: user.displayName)
                                                            
        }, notActivated: {
            self.startTimer()
        }) { (error: ErrorModel) in
            self.startTimer()
        }
    }
    
    
    // MARK: - Tools
    
    
    private func generateNewCodeCommand() -> GenerateNewCodeLinkDeviceCommand {
        return GenerateNewCodeLinkDeviceCommand.init(delegate: self)
    }
    
    
    private func watchNowCommand() -> WatchNowLinkDeviceCommand {
        return WatchNowLinkDeviceCommand.init(delegate: self)
    }
    
    
    private func loadAuthCode() {
        
        self.getAuthCode(completion: { (authCode: String) in
            
            self.authCode = authCode
            self.updateInterfaceWithAuthCode(buttonIsEnabled: false)
            
        }) { (error: ErrorModel) in
            self.updateInterfaceForDefault(buttonIsEnabled: true)
            //            UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.linkDevice)
        }
    }
    
    
    private func getAuthCode(completion: @escaping (String) -> Void,
                             failure: @escaping (ErrorModel) -> Void) {
        
        AuthService.sharedInstance.getSessionToken(completion: {
            self.generateAuthCode(completion: { (authCode: String) in
                completion(authCode)
            }, failure: { (error: ErrorModel) in
                failure(error)
            })
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    private func generateAuthCode(completion: @escaping (String) -> Void,
                                  failure: @escaping (ErrorModel) -> Void) {
        
        AuthService.sharedInstance.getAuthCode(completion: { (authCode: String) in
            completion(authCode)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
}

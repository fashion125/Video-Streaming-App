//
//  SettingsScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/14/17.
//
//

import UIKit

protocol SettingsScenarioDelegate {
    
    func didUpdateUser(settingScenario: SettingsScenario!)
}

class SettingsScenario: Scenario, SettingsVCDelegate, LinkDeviceScenarioDelegate, MembershipScenarioDelegate {

    private(set) var rootVC: UITabBarController!
    private(set) var delegate: SettingsScenarioDelegate!
    private(set) var settingsVC: SettingsVC!
    private(set) var settingsVCNC: UINavigationController!
    
    private(set) var linkDeviceScenario: LinkDeviceScenario!
    private(set) var membershipScenario: MembershipScenario!
    
    
    // MARK: - Init methods
    
    
    init(rootVC: UITabBarController!, delegate: SettingsScenarioDelegate) {
        super.init()
        
        self.rootVC = rootVC
        self.delegate = delegate
        
        self.createSettingsScreen()
    }
    
    
    // MARK: -
    
    
    override func start() {
        
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: - Tools
    
    
    private func createSettingsScreen() {
        self.settingsVC = SettingsVC.init(delegate: self)
        self.settingsVCNC = UINavigationController.init(rootViewController: self.settingsVC)
        self.settingsVCNC.tabBarItem = UITabBarItem.init(title: "SETTINGS".localized, image: nil, tag: 1)
    }
    
    
    // MARK: - SettingsVCDelegate methods 
    
    
    func didPressLogOutButton(settingsVC: SettingsVC!) {
        
        if !AuthService.sharedInstance.isAuthorized() {
            UIAlertController.showAlert(title: "You are not authorized!", message: "Please link device for you Kanopy account!", fromVC: self.settingsVC)
            return
        }
        
        UIAlertController.showAlert(title: "Log Out", message: "Are you sure you want to exit Kanopy?", fromVC: self.settingsVC, trueButton: { 
            AuthService.sharedInstance.unauthorized()
            self.settingsVC.navigationController?.popViewController(animated: true)
            self.rootVC.selectedIndex = 0
            self.delegate.didUpdateUser(settingScenario: self)
        }) { 
            
        }
    }
    
    
    func didPressLinkDeviceButton(settingsVC: SettingsVC!) {
        self.linkDeviceScenario = LinkDeviceScenario.init(rootVC: self.settingsVC, delegate: self)
        self.linkDeviceScenario.start()
    }
    
    
    func didPressMembershipButton(settingsVC: SettingsVC!) {
        
        if AuthService.sharedInstance.isAuthorized() {
            self.membershipScenario = MembershipScenario.init(rootVC: self.settingsVC, delegate: self)
            self.membershipScenario.start()
        } else {
            let message = "Your Apple TV  is not linked to your Kanopy account yet"
            UIAlertController.showAlertWithButtons(title: "", message: message, fromVC: self.settingsVC, firstButtonTitle: "Link Device".localized, secondButtonTitle: "", trueButton: { 
                self.didPressLinkDeviceButton(settingsVC: self.settingsVC)
            }, falseButton: { 
                
            })
        }
    }
    
    
    func didPressSupportButton(settingsVC: SettingsVC!) {
        let message = "To report an issue or for support, please visit:\nkanopy.com/help"
        UIAlertController.showAlertWithButtons(title: "Support".localized, message: message, fromVC: self.settingsVC, firstButtonTitle: "Back".localized, secondButtonTitle: "", trueButton: {
        }, falseButton: {
            
        })
    }
    
    
    // MARK: - LinkDeviceScenarioDelegate methods
    
    
    func didPressWatchNowButton(scenario: LinkDeviceScenario!) {
        self.rootVC.selectedIndex = 0
        self.delegate.didUpdateUser(settingScenario: self)
    }
    
    
    // MARK: - MembershipScenarioDelegate methods 
    
    
    func didChoosedNewMembership(membershipScenario: MembershipScenario!) {
        self.rootVC.dismiss(animated: false, completion: nil)
        self.rootVC.selectedIndex = 0
        self.delegate.didUpdateUser(settingScenario: self)
    }
}

//
//  SettingsScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

protocol SettingsScenarioDelegate {
    
}


class SettingsScenario: Scenario, SettingsVCDelegate, AlertViewDelegate, ChooseItemVCDelegate, LinkYourRokuVCDelegate {

    var nvc: MenuNavigationController!
    var settingsVC: SettingsVC!
    var chooseItemVC: ChooseItemVC!
    var linkYourRokuVC: LinkYourRokuVC!
    
    
    // MARK: - Init method 
    
    
    init(nvc: MenuNavigationController!, delegate: SettingsScenarioDelegate!) {
        super.init()
        
        self.nvc = nvc
    }
    
    override func start() {
        self.showSettingsScreen()
    }
    
    override func stop() {
        
    }
    
    
    /** Method show setting view controller */
    func showSettingsScreen() {
        
        self.settingsVC = SettingsVC.init(delegate: self)
        self.updateSettingsVM()
        
        self.nvc.pushViewController(self.settingsVC, animated: true)
    }
    
    
    func updateSettingsVM() {
        let settingVM = SettingsVM.init(delegate: self, linkYourRokuDelegate: self)
        self.settingsVC.update(with: settingVM)
    }
    
    
    func updateVideoQualityVM() {
        let chooseItemVM = VideoQualityVM.init(title: "VIDEO_QUALITY".localized)
        self.chooseItemVC.update(with: chooseItemVM)
    }
    
    
    func updateLinkYourRokuVM() {
        let linkYourRokuVM = LinkYourRokuVM.init(title: "LINK_YOUR_ROKU".localized, delegate: self)
        self.linkYourRokuVC.update(with: linkYourRokuVM)
    }
    
    
    // MARK: - LinkYourRokuVCDelegate methods
    
    
    func didPressToBackButton(linkYourRokuVC: LinkYourRokuVC!) {
        self.settingsVC.navigationController?.popViewController(animated: true)
    }
    
    
    func didValidCodeRoku(code: String!) {
        if code.range(of: "^[a-zA-Z0-9]{6}$", options: .regularExpression) == nil {
            UIAlertController.showAlert(title: "CODE_SHOULD_BE_ALPHANUMERICAL_AND_SIX_CHARACTERS_LONG".localized, message: "", fromVC: self.linkYourRokuVC)
        } else {
            AuthService.sharedInstance.activateAuthcode(authcode: code, completion: {
                let alertController = UIAlertController(title: "ROKU_SUCCESSFULLY_LINKED".localized, message: "", preferredStyle:UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler:
                    { (action: UIAlertAction!) -> Void in
                        self.didPressToBackButton(linkYourRokuVC: self.linkYourRokuVC)
                }))
                self.linkYourRokuVC.present(alertController, animated: true, completion: nil)
            }, failure: { (error) in
                UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.linkYourRokuVC)
            })
        }
    }
    
    
    func didPressLinkYourRoku() {
        
        self.linkYourRokuVC = LinkYourRokuVC.init(delegate: self)
        self.updateLinkYourRokuVM()
        
        self.settingsVC.navigationController?.pushViewController(linkYourRokuVC, animated: true)
    }
    
    
    // MARK: - SettingsVCDelegate methods
    
    
    func didPressSignOutButton() {
        
        let alertView = AlertView.init(titleText: "SIGN_OUT_MESSAGE".localized,
                                       parentVC: self.settingsVC,
                                       delegate: self)
        alertView.show()
    }
    
    
    func didPressSignInButton() {
        RequestService.sharedInstance.notifyAllObserversAboutUnauthorized()
    }
    
    
    func didUpdateCellularDataUsage(_ value: Bool!) {
        SettingsService.sharedInstance.updateCellularDataUsage(value)
    }
    
    
    func didUpdateClosedCaptions(_ value: Bool!) {
        SettingsService.sharedInstance.updateClosedCaptions(value)
    }
    
    
    func didPressVideoQuality() {
        
        self.chooseItemVC = ChooseItemVC.init(delegate: self)
        self.updateVideoQualityVM()
        
        self.settingsVC.navigationController?.pushViewController(chooseItemVC, animated: true)
    }
    
    
    func didPressFeedback() {
        // Opening Mail App with some initialized elements
        let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        let buildVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!
        
        let subject = "Feedback about Kanopy iOS"
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        var body = "\n\nApp Information:\n"
        body += "App Version: " + String(version) + " (" + String(buildVersion) + ")\n"
        body += "\nDevice Information:\n"
        body += "Device model: " + machineString + "\n"
        body += "iOS Version: " + UIDevice.current.systemVersion + "\n"
        
        let uri = "mailto:support@kanopy.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL: NSURL = NSURL(string: uri!) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.openURL(emailURL as URL)
            }
        }
    }
    
    
    func didPressBackButton(settingsVC: SettingsVC!) {
        self.nvc.popViewController(animated: true)
    }
    
    
    // MARK: - AlertViewDelegate methods
    
    
    func didPressToConfirmButton(alertView: AlertView!) {
        
        AuthService.sharedInstance.unauthorized()
        alertView.hide()
        
        self.settingsVC.viewModel.showLoadCellModel()
        self.settingsVC.update(with: self.settingsVC.viewModel)
        
        AuthService.sharedInstance.getSessionToken(completion: { 
            self.updateSettingsVM()
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.settingsVC)
        }
    }
    
    
    func didPressToCloseButton(alertView: AlertView!) {
        alertView.hide()
    }
    
    
    func didPressToCancelButton(alertView: AlertView!) {
        alertView.hide()
    }
    
    
    // MARK: - ChooseItemVCDelegate
    
    func didPressToBackButton(chooseItemVC: ChooseItemVC!) {
        self.settingsVC.navigationController?.popViewController(animated: true)
    }
    
    
    func didPressToCell(indexPath: IndexPath!, chooseItemVC: ChooseItemVC!) {
        
        let cm: ChooseItemCellModel = chooseItemVC.viewModel.cellModel(indexPath: indexPath) as! ChooseItemCellModel
        
        SettingsService.sharedInstance.updateVideoQuality(cm.keyValue)
        
        self.updateVideoQualityVM()
        
        self.updateSettingsVM()
        self.settingsVC.navigationController?.popViewController(animated: true)
    }
}

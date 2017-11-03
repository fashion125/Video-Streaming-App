//
//  SettingsVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/14/17.
//
//

import UIKit

protocol SettingsVCDelegate {
    
    /** Method is call when user tap to log out button */
    func didPressLogOutButton(settingsVC: SettingsVC!)
    
    /** Method is call when user tap to link device button */
    func didPressLinkDeviceButton(settingsVC: SettingsVC!)
    
    /** Method is call when user tap to membership button */
    func didPressMembershipButton(settingsVC: SettingsVC!)
    
    /** Method is call when user tap to support button */
    func didPressSupportButton(settingsVC: SettingsVC!)
}


class SettingsVC: GenericVC {

    private(set) var delegate: SettingsVCDelegate!
    
    
    // MARK: - Init methods 
    
    
    @IBOutlet weak var membershipButton: UIButton!
    @IBOutlet weak var linkDeviceButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    
    
    init(delegate: SettingsVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SETTINGS".localized

        self.linkDeviceButton.setTitle("LINK_DEVICE".localized, for: .normal)
        self.logOutButton.setTitle("SIGN_OUT".localized, for: .normal)
        self.membershipButton.setTitle("MEMBERSHIP".localized, for: .normal)
        self.supportButton.setTitle("SUPPORT".localized, for: .normal)
        
        self.logOutButton.updateButtonForAppleTV()
        self.linkDeviceButton.updateButtonForAppleTV()
        self.membershipButton.updateButtonForAppleTV()
        self.supportButton.updateButtonForAppleTV()
    }
    
    
    // MARK: - Tools 
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
    
    
    // MARK: -
    
    
    
    @IBAction func linkDeviceButtonAction(_ sender: Any) {
        self.delegate.didPressLinkDeviceButton(settingsVC: self)
    }
    
    
    
    @IBAction func logOutButtonActino(_ sender: Any) {
        self.delegate.didPressLogOutButton(settingsVC: self)
    }
    
    
    @IBAction func membershipButtonAction(_ sender: Any) {
        self.delegate.didPressMembershipButton(settingsVC: self)
    }
    
    
    @IBAction func supportButtonAction(_ sender: Any) {
        self.delegate.didPressSupportButton(settingsVC: self)
    }
    
}

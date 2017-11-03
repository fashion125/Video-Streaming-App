//
//  GenericVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit
import GoogleCast

class GenericVC: UIViewController, GCKDiscoveryManagerListener {

    var loadIndicator: UIActivityIndicatorView? = nil
    
    var addChromecastIfPossible = true
    
    var menuIconPresent = false
    
    // MARK: - Override methods 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GCKCastContext.sharedInstance().discoveryManager.add(self)
        
        self.updateDefaultInterface()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateLoadIndicatorPosition()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.didUpdateCastState()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateCastState), name: NSNotification.Name.gckCastStateDidChange, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.gckCastStateDidChange, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func didUpdateDeviceList() {
        self.viewDidLoad()
    }
    
    
    func didUpdateCastState() {
        if (self.menuIconPresent) {
            self.initializeMenuBarItem()
        } else {
            self.showBackButton()
        }
    }
    
    
    // MARK: - Update interface methods 
    
    
    /** Show menu bar button item method */
    func showMenuBarItem() {
        self.menuIconPresent = true
        self.menuNavigationController()?.addMenu(parentView: self.view)
        self.initializeMenuBarItem()
    }
    
    
    /** Initialize menu bar button item method */
    func initializeMenuBarItem() {
        if (GCKCastContext.sharedInstance().discoveryManager.deviceCount > 0 && AuthService.sharedInstance.isAuthorized()) {
            let menuBarButtonItem = self.menuBarButtonItem()
            var chromecastBarButtonItem: UIBarButtonItem?
            
            if (GCKCastContext.sharedInstance().castState == GCKCastState.notConnected) {
                chromecastBarButtonItem = self.chromecastNotConnectedBarButtonItem()
            } else if (GCKCastContext.sharedInstance().castState == GCKCastState.connecting) {
                chromecastBarButtonItem = self.chromecastConnectingBarButtonItem()
            } else if (GCKCastContext.sharedInstance().castState == GCKCastState.connected) {
                chromecastBarButtonItem = self.chromecastConnectedBarButtonItem()
            } else if (GCKCastContext.sharedInstance().castState == GCKCastState.noDevicesAvailable) {
                chromecastBarButtonItem = self.chromecastNotConnectedBarButtonItem()
            }
            
            navigationItem.setLeftBarButtonItems([menuBarButtonItem], animated: false)
            var barButtonItems : [UIBarButtonItem]!
            if let barButtonItem = navigationItem.rightBarButtonItem  {
                barButtonItems = [barButtonItem, chromecastBarButtonItem!]
            }else{
                barButtonItems = [chromecastBarButtonItem!]
            }
            navigationItem.setRightBarButtonItems(barButtonItems, animated: false)

        } else {
            let menuBarButtonItem = self.menuBarButtonItem()
            
            navigationItem.setLeftBarButtonItems([menuBarButtonItem], animated: false)
        }
        
        /*let menuBarButtonItem = self.menuBarButtonItem()
        
        navigationItem.setLeftBarButtonItems([menuBarButtonItem], animated: false)*/
    }
    
    
    /** Show back button item method */
    func showBackButton() {
        self.menuIconPresent = false
        if (self.addChromecastIfPossible && GCKCastContext.sharedInstance().discoveryManager.deviceCount > 0 && AuthService.sharedInstance.isAuthorized()) {
            let backBarButtonItem = self.backBarButtonItem()
            var chromecastBarButtonItem: UIBarButtonItem?
            
            if (GCKCastContext.sharedInstance().castState == GCKCastState.notConnected) {
                chromecastBarButtonItem = self.chromecastNotConnectedBarButtonItem()
            } else if (GCKCastContext.sharedInstance().castState == GCKCastState.connecting) {
                chromecastBarButtonItem = self.chromecastConnectingBarButtonItem()
            } else if (GCKCastContext.sharedInstance().castState == GCKCastState.connected) {
                chromecastBarButtonItem = self.chromecastConnectedBarButtonItem()
            } else if (GCKCastContext.sharedInstance().castState == GCKCastState.noDevicesAvailable) {
                chromecastBarButtonItem = self.chromecastNotConnectedBarButtonItem()
            }
            
            navigationItem.setLeftBarButtonItems([backBarButtonItem], animated: false)
            var barButtonItems : [UIBarButtonItem]!
            if let barButtonItem = navigationItem.rightBarButtonItem  {
                barButtonItems = [barButtonItem, chromecastBarButtonItem!]
            }else{
                barButtonItems = [chromecastBarButtonItem!]
            }
            navigationItem.setRightBarButtonItems(barButtonItems, animated: false)

        } else {
            let backBarButtonItem = self.backBarButtonItem()
            
            navigationItem.setLeftBarButtonItems([backBarButtonItem], animated: false)
        }
        
        /*let backBarButtonItem = self.backBarButtonItem()
        
        navigationItem.setLeftBarButtonItems([backBarButtonItem], animated: false)*/
    }
    
    /** Show app logo on the navigation bar */
    func showLogo() {
        let logoView = UIImageView.init(image: UIImage.init(named: "logo_icon"))
        logoView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 30)
        logoView.contentMode = .scaleAspectFill
        navigationItem.titleView = logoView
    }
    
    /** Method update title with custom attributes 
        - parameter title: title string value
     */
    func showTitle(with title: String!) {
        
        self.navigationItem.titleView = self.titleLabel(title)
    }
    
    
    func titleLabel(_ titleText: String!) -> UILabel {
        
        let rect = CGRect.init(x: 0, y: 0, width: 100.0, height: 20.0)
        let label = UILabel.init(frame: rect)
        label.text = titleText
        label.font = UIFont(name: "AvenirNextLTPro-Demi", size: 17)!
        label.textColor = UIColor.white
        
        label.sizeToFit()
        
        return label
    }
    
    
    /** Show load indicator on the center view */
    func showLoadIndicator() {
        self.loadIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        self.updateLoadIndicatorPosition()
        self.loadIndicator?.startAnimating()
        self.view.addSubview(self.loadIndicator!)
        
    }
    
    /** Hide load indicator */
    func hideLoadIndicator() {
        self.loadIndicator?.stopAnimating()
        self.loadIndicator?.removeFromSuperview()
        self.loadIndicator = nil
    }
    
    /** Method centered load inicator */
    func updateLoadIndicatorPosition() {
        if self.loadIndicator != nil {
            self.loadIndicator?.center = CGPoint.init(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    
    // MARK: - Tools
    
    
    private func updateDefaultInterface() {
        self.view.backgroundColor = UIColor.mainBackgroundGreyColor()
    }
    
    private func menuBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(GenericVC.didPressToMenuBarButtonItem))
    }
    
    private func chromecastNotConnectedBarButtonItem() -> UIBarButtonItem {
        let image = UIImage.init(named: "chromecast_icon_not_connected_white_small")?.withRenderingMode(.alwaysOriginal)
        return UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(GenericSearchVC.didPressToRokuButton))
    }
    
    private func chromecastConnectingBarButtonItem() -> UIBarButtonItem {
        let image = UIImage.gif(name: "chromecast_icon_connecting_white_small")?.withRenderingMode(.alwaysOriginal)
        return UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(GenericSearchVC.didPressToRokuButton))
    }
    
    private func chromecastConnectedBarButtonItem() -> UIBarButtonItem {
        let image = UIImage.init(named: "chromecast_icon_connected_blue_small")?.withRenderingMode(.alwaysOriginal)
        return UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(GenericSearchVC.didPressToRokuButton))
    }
    
    private func backBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem.init(image: #imageLiteral(resourceName: "back_icon"), style: .plain, target: self, action: #selector(GenericVC.didPressToBackButton))
    }
    
    func menuNavigationController() -> MenuNavigationController? {
        return self.navigationController as? MenuNavigationController
    }
    
    // MARK: - Actions 
    
    func didPressToMenuBarButtonItem() {
        self.menuNavigationController()?.sideMenu?.toggleMenu()
    }
    
    func didPressToBackButton() {
        
    }
    
    func didPressToRokuButton() {
        GCKCastContext.sharedInstance().presentCastDialog()
    }
}

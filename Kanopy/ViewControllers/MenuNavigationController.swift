//
//  MenuNavigationController.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit

protocol MenuNavigationControllerDelegate {
    func didCloseSideMenu(sideMenu: ENSideMenu!, menuNavigationConteroller:MenuNavigationController!)
}

class MenuNavigationController: UINavigationController, ENSideMenuProtocol, ENSideMenuDelegate {

    var sideMenu : ENSideMenu?
    let sideMenuAnimationType : ENSideMenuAnimation = .default
    private(set) var menuVC: MenuVC?
    private var blackView: UIView?
    
    var menuNCDelegate: MenuNavigationControllerDelegate?
    
    
    // MARK: - Init methods 
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.updateNavigationBar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //self.sideMenu?.menuWidth = self.view.frame.size.width - self.view.frame.size.width/4
        
        if self.blackView != nil {
            self.blackView?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        if (self.sideMenu != nil && (self.sideMenu?.isMenuOpen)!) {
            self.sideMenu?.forceSideMenu()
        }
    }
    
    
    // MARK: - Tools 
    
    
    /** Method update navigation bar */
    func updateNavigationBar() {
        /// Change backgorund for navigation bar
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        
        /// Change bar tint and tint color
        navigationBar.barTintColor = UIColor.navBarBackgroundColor()
        navigationBar.tintColor = UIColor.navBarTintColor()
        
        /// is transculent is false
        navigationBar.isTranslucent = false
    }
    
    
    // MARK: - Open methods 
    
    
    func bringMenuToFront() {
        self.sideMenu?.bringMenuToFront()
    }
    
    
    /** Method set new menu view controller 
     - parameter menuVC: new menu view controller
    */
    open func updateMenuVC(with menuVC: MenuVC!) {
        self.menuVC = menuVC
    }
    
    
    /** Method add menu on the navigation controller
     -  parametr parentView current center view controller's view
     */
    open func addMenu(parentView: UIView!) {
        
        self.blackView = UIView.init()
        self.blackView?.backgroundColor = UIColor.black
        self.blackView?.layer.opacity = 0.0
        // Simple hack to get a big square has the blackview so it fits both portrait and landscape modes
        self.blackView?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.blackView?.isHidden = true
        parentView.addSubview(self.blackView!)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.blackViewClicked(_:)))
        self.blackView?.addGestureRecognizer(tap)
        
        self.sideMenu = ENSideMenu.init(sourceView: parentView, menuViewController: self.menuVC!, menuPosition: .left)
        self.sideMenu?.menuWidth = self.view.frame.size.width - self.view.frame.size.width/4
        self.sideMenu?.delegate = self
        
        view.bringSubview(toFront: navigationBar)
        view.bringSubview(toFront: (self.menuVC?.view)!)
        bringMenuToFront()
    }
    
    
    func blackViewClicked(_ sender:UITapGestureRecognizer){
        sideMenu?.hideSideMenu(completion: {})
    }
    
    
    // MARK: - ENSideMenuProtocol methods 
    
    
    func setContentViewController(_ contentViewController: UIViewController) {
        
    }
    
    
    /** Method is call when menu will open */
    func sideMenuWillOpen() {
        self.blackView?.isHidden = false
        bringMenuToFront()
        UIView.animate(withDuration: 0.2) { 
            self.blackView?.layer.opacity = 0.5
        }
    }
    
    
    /** Method is call when menu will close */
    func sideMenuWillClose() {
        bringMenuToFront()
        UIView.animate(withDuration: 0.2,
                       animations: { 
                        self.blackView?.layer.opacity = 0.0
        }) { (isTrue: Bool) in
            self.blackView?.isHidden = true
        }
    }
    
    
    /** Method is call when menu did close */
    func sideMenuDidClose() {
        if self.menuNCDelegate != nil {
            self.menuNCDelegate?.didCloseSideMenu(sideMenu: self.sideMenu,
                                                  menuNavigationConteroller: self)
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

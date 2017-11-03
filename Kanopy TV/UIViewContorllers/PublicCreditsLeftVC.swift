//
//  PublicCreditsLeftVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/8/17.
//
//

import UIKit

class PublicCreditsLeftVC: GenericVC, AuthServiceDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCreditsLeft()
        
        AuthService.sharedInstance.addObserver(observer: self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AuthService.sharedInstance.removeObserver(observer: self)
    }
    
    
    // MARK: -
    
    
    private func updateView() {
        
        self.countLabel()?.layer.borderWidth = 2.0
        self.countLabel()?.layer.borderColor = UIColor.mainOrangeColor().cgColor
        self.countLabel()?.layer.cornerRadius = 8.0
    }
    
    
    func updateCreditsLeft() {
        
        if AuthService.sharedInstance.isHaveCredits() {
            self.addCreditsLeft()
        } else {
            self.removeCreditsLeft()
        }
    }
    
    
    func addCreditsLeft() {
        self.publicCreditsLeftView()?.isHidden = false
        self.countLabel()?.text = String(AuthService.sharedInstance.currentCreditsValue())
    }
    
    
    func removeCreditsLeft() {
        self.publicCreditsLeftView()?.isHidden = true
    }
    
    
    // MARK: - AuthServiceDelegate methods
    
    
    func notifyAboutChangeCreditLeft() {
        self.updateCreditsLeft()
    }
    
    
    // MARK: - Tools 
    
    
    open func countLabel() -> UILabel? {
        
        assertionFailure("Must be implement in subclass")
        
        return nil
    }
    
    
    open func titleLabel() -> UILabel? {
        
        assertionFailure("Must be implement in subclass")
        
        return nil
    }
    
    
    open func publicCreditsLeftView() -> UIView? {
        
        assertionFailure("Must be implement in subclass")
        
        return nil
    }
}

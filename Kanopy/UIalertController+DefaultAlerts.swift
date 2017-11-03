//
//  UIalertController+DefaultAlerts.swift
//  optum-soft-install-app
//
//  Created by Ilya Katrenko on 9/20/16.
//  Copyright © 2016 Design and Test Lab. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /**
     Show alert view with given parameters.
     - parameter title:     Title of alert.
     - parameter message:   Message of alert.
     - parameter fromVC:    View controller from which alert should be shown.
     */
    class func showAlert(title: String, message: String, fromVC: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alertController.view.tintColor = UIColor.mainOrangeColor()
        fromVC.present(alertController, animated: true, completion: nil)
    }
    
    
    class func showAlert(title: String, message: String, fromVC: UIViewController,
                         okButton: @escaping (() -> Void)) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            okButton()
        }))
        alertController.view.tintColor = UIColor.mainOrangeColor()
        fromVC.present(alertController, animated: true, completion: nil)
    }
    
    
    class func showAlert(title: String, message: String, fromVC: UIViewController!,
                         trueButton: @escaping (() -> Void),
                         falseButton: @escaping (() -> Void)) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title: "YES".localized,
                                                     style: .default,
                                                     handler: { (action: UIAlertAction) in
                                                        trueButton()
        }))
        alertController.addAction(UIAlertAction.init(title: "NO".localized,
                                                     style: .destructive,
                                                     handler: { (action: UIAlertAction) in
                                                        falseButton()
        }))
        
        fromVC.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Show "not implemented yet" alert.
     - parameter fromVC:    View controller from which alert should be shown.
     */
    class func showAlertNotImplemented(fromVC: UIViewController) {
        self.showAlert(title: "!", message: "Not implemented yet", fromVC: fromVC)
    }
    

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
}

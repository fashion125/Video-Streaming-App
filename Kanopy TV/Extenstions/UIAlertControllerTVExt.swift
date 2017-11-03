//
//  UIAlertControllerTVExt.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/20/17.
//
//

import Foundation
import UIKit

extension UIAlertController {
    /**
     Show alert view with given parameters.
     - parameter title:     Title of alert.
     - parameter message:   Message of alert.
     - parameter fromVC:    View controller from which alert should be shown.
     */
    class func showAlert(title: String, message: String, fromVC: UIViewController) {
        
        let ac = CustomAlertControllerVC.init(title: title, message: message, buttonTitle: "Ok") { () -> Void! in
            fromVC.dismiss(animated: true, completion: nil)
        }
        
        fromVC.present(ac, animated: true, completion: nil)
    }
    
    
    class func showAlert(title: String, message: String, fromVC: UIViewController,
                         okButton: @escaping (() -> Void)) {
        
        let ac = CustomAlertControllerVC.init(title: title, message: message, buttonTitle: "Ok") { () -> Void! in
            fromVC.dismiss(animated: true, completion: { 
                okButton()
            })
        }
        
        fromVC.present(ac, animated: true, completion: nil)
    }
    
    
    class func showAlert(title: String, message: String, fromVC: UIViewController!,
                         trueButton: @escaping (() -> Void),
                         falseButton: @escaping (() -> Void)) {
        
        let ac = CustomAlertControllerVC.init(title: title, message: message,
                                              buttonTitle: "Yes, Exit".localized,
                                              additionalButtonTitle: "NO".localized,
                                              actionBlock: { () -> Void! in
                                                
                                                fromVC.dismiss(animated: true, completion: { 
                                                    trueButton()
                                                })
                                                
        }) { () -> Void! in
            fromVC.dismiss(animated: true, completion: {
                falseButton()
            })
        }
        
        fromVC.present(ac, animated: true, completion: nil)
    }
    
    
    class func showAlertWithButtons(title: String, message: String!, fromVC: UIViewController!,
                                    firstButtonTitle: String!, secondButtonTitle: String,
                                    trueButton: @escaping (() -> Void),
                                    falseButton: @escaping (() -> Void)) {
        
        let ac = CustomAlertControllerVC.init(title: title, message: message,
                                              buttonTitle: firstButtonTitle,
                                              additionalButtonTitle: secondButtonTitle,
                                              actionBlock: { () -> Void! in
                                                fromVC.dismiss(animated: true, completion: { 
                                                    trueButton()
                                                })
        }) { () -> Void! in
            fromVC.dismiss(animated: true, completion: { 
                falseButton()
            })
        }
        
        fromVC.present(ac, animated: true, completion: nil)
    }
    
    /**
     Show "not implemented yet" alert.
     - parameter fromVC:    View controller from which alert should be shown.
     */
    class func showAlertNotImplemented(fromVC: UIViewController) {
        self.showAlert(title: "!", message: "Not implemented yet", fromVC: fromVC)
    }
}

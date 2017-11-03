//
//  KeyboardVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit

class KeyboardVC: GenericVC {

    // MARK: - View lifecycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: NSNotification.Name.UIKeyboardDidHide,
                                               object: nil)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardDidHide,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardDidShow,
                                                  object: nil)
    }
    
    // MARK: - Keyboard notifications
    
    /**
     Will be called when keyboard is about to be shown in view controller.
     - parameter notification:    Object that contains data about keyboard animation and its frame.
     */
    func keyboardWillShow(notification: NSNotification) {
        assertionFailure("Must be implemented in subclasses")
    }
    
    /**
     Will be called when keyboard is about to be hidden.
     */
    func keyboardWillHide() {
        assertionFailure("Must be implemented in subclasses")
    }
    
    
    /**
     Will be called when keyboard is about to be shown in view controller.
     - parameter notification:    Object that contains data about keyboard animation and its frame.
     */
    func keyboardDidShow(notification: NSNotification) {
        assertionFailure("Must be implemented in subclasses")
    }
    
    /**
     Will be called when keyboard is about to be hidden.
     */
    func keyboardDidHide() {
        assertionFailure("Must be implemented in subclasses")
    }
}

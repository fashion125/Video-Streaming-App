//
//  UINavigationControllerExt.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 24/07/2017.
//
//

import Foundation

extension UINavigationController {
    //Same function as "popViewController", but allow us to know when this function ends
    func popViewControllerWithHandler(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    
    //Same function as "pushViewController", but allow us to know when this function ends
    func pushViewControllerWithHandler(viewController: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
}

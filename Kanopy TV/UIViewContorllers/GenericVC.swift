//
//  GenericVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/14/17.
//
//

import UIKit

protocol GenericVCDelegate {
    
    /** This method is call when user show or back to current vc */
    func viewWillAppear()
}

class GenericVC: UIViewController {

    var loadIndicator: UIActivityIndicatorView? = nil
    
    open var genericVCDelegate: GenericVCDelegate?
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateBackgroundColor()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.genericVCDelegate != nil {
            self.genericVCDelegate?.viewWillAppear()
        }
    }
    
    
    // MARK: - Tools 
    
    
    open func updateBackgroundColor() {
        self.view.backgroundColor = UIColor.mainBackgroundColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 16.0/255.0,
                                                                                green: 16.0/255.0,
                                                                                blue: 16.0/255.0,
                                                                                alpha: 1.0)
    }
    
    
    /** Show load indicator on the center view */
    func showLoadIndicator() {
        self.loadIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
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
}

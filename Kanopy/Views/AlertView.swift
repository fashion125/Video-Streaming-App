//
//  AlertView.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/26/17.
//
//

import UIKit

protocol AlertViewDelegate {
    
    /** This method is call when user tap to close button */
    func didPressToCloseButton(alertView: AlertView!)
    
    /** This method is call when user tap to cancel button */
    func didPressToCancelButton(alertView: AlertView!)
    
    /** This method is call when user tap to confirm button */
    func didPressToConfirmButton(alertView: AlertView!)
}


class AlertView: UIView {

    var view: UIView!
    private(set) var delegate: AlertViewDelegate!
    private(set) var titleText: String! = ""
    private(set) var parentVC: UIViewController!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    // MARK: - Init methods
    
    
    init(titleText: String!, parentVC: UIViewController!, delegate: AlertViewDelegate!) {
        super.init(frame: parentVC.view.bounds)
        
        self.titleText = titleText
        self.delegate = delegate
        self.parentVC = parentVC
        
        self.xibSetup()
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        /// Setup view from .xib file
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        /// Setup view from .xib file
        self.xibSetup()
    }
    
    
    // MARK: - Load methods
    
    
    private func xibSetup() {
        
        self.view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        self.view.frame = bounds
        // Make the view stretch with containing view
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.view.backgroundColor = UIColor.clear
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.updateView()
        self.addSubview(view)
    }
    
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AlertView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    func updateView() {
        
        self.titleLabel.text = self.titleText
        self.confirmButton.setTitle("YES".localized, for: .normal)
        self.cancelButton.setTitle("NO".localized, for: .normal)
        
        self.confirmButton.layer.cornerRadius = 4.0
        self.cancelButton.layer.cornerRadius = 4.0
        self.cancelButton.layer.borderWidth = 1.0
        self.confirmButton.layer.borderWidth = 1.0
        self.confirmButton.layer.borderColor = UIColor.white.cgColor
        self.cancelButton.layer.borderColor = UIColor.white.cgColor
    }
    
    
    // MARK: - Tools 
    
    
    func show() {
        
        self.layer.opacity = 0.0
        self.parentVC.view.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.layer.opacity = 1.0
        }
    }
    
    
    func hide() {
        
        UIView.animate(withDuration: 0.3,
        animations: {
            self.layer.opacity = 0.0
        }) { (isTrue: Bool) in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - Action 
    
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        self.delegate.didPressToConfirmButton(alertView: self)
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.delegate.didPressToCancelButton(alertView: self)
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.delegate.didPressToCloseButton(alertView: self)
    }
}

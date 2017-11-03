//
//  OrientationService.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/6/17.
//
//

import UIKit

protocol OrientationServiceDelegate {
    
    func didChangeOrientation()
}

class OrientationService: NSObject {

    private(set) var orientationValue: UIInterfaceOrientationMask! = .portrait
    private var observers: NSMutableArray?
    
    /// Instance
    static let sharedInstance = OrientationService()
    
    
    // MARK: -
    
    
    override init() {
        super.init()
        
        self.observers = NSMutableArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // MARK: - Observers methods
    
    
    open func addObserver(observer: OrientationServiceDelegate!) {
        if !(self.observers?.contains(observer))! {
            self.observers?.add(observer)
        }
    }
    
    
    open func removeObserver(observer: OrientationServiceDelegate!) {
        if (self.observers?.contains(observer))! {
            self.observers?.remove(observer)
        }
    }
    
    
    open func notifyAboutDidChangeOrientation() {
        
        let observersArray = self.observers
        
        for delegate in observersArray! {
            let dg = delegate as! OrientationServiceDelegate
            dg.didChangeOrientation()
        }
    }
    
    
    // MARK: -
    
    
    func rotated() {
        self.notifyAboutDidChangeOrientation()
    }
    
    
    open func updateOrientation(_ orientation: UIInterfaceOrientationMask!) {
        self.orientationValue = orientation
    }
    
    
    open func orientation() -> UIInterfaceOrientationMask! {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return self.orientationValue
        } else {
            return .all
        }
    }
    
    
    open func changeToPortraitOrientation() {
        
        self.updateOrientation(.portrait)
        
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            UIView.animate(withDuration: 0.3, animations: { 
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            })
        }
    }
    
    
    open func shouldAutorotate() -> Bool {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return false
        } else {
            return true
        }
    }
}

//
//  RefreshService.swift
//  Kanopy
//
//  Created by Boris Esanu on 16.06.17.
//
//

import UIKit

protocol RefreshServiceDelegate {
    
    /** This method is call when user enter foreground app */
    func appWillEnterForeground()
    
    /** This method is called when the Side Menu should be refreshed */
    func refreshSideMenu()
}

class RefreshService: NSObject {

    private var observers: NSMutableArray?
    
    /// Instance
    static var sharedInstance = RefreshService()
    
    
    // MARK: - Init methods 
    
    
    override init() {
        super.init()
        
        self.observers = NSMutableArray()
    }
    
    
    // MARK: - Observers methods
    
    
    open func addObserver(observer: RefreshServiceDelegate!) {
        if !(self.observers?.contains(observer))! {
            self.observers?.add(observer)
        }
    }
    
    
    open func removeObserver(observer: RefreshServiceDelegate!) {
        if (self.observers?.contains(observer))! {
            self.observers?.remove(observer)
        }
    }
    
    
    // MARK: - Open methods 
    
    
    open func notifyAboutAppWillEnterForeground() {
        let observersArray = self.observers
        
        for delegate in observersArray! {
            let dg = delegate as! RefreshServiceDelegate
            dg.appWillEnterForeground()
        }
    }
    
    
    open func notifyAboutRefreshSideMenu() {
        let observersArray = self.observers
        
        for delegate in observersArray! {
            let dg = delegate as! RefreshServiceDelegate
            dg.refreshSideMenu()
        }
    }
}

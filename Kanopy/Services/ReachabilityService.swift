//
//  ReachabilityService.swift
//  Kanopy
//
//  Created by Boris Esanu on 14.06.17.
//
//

import UIKit
import Foundation
import SystemConfiguration
import AFNetworking


protocol ReachabilityServiceDelegate {
    
    func didConnectToInternet()
}


class ReachabilityService: NSObject {

    private(set) var networkManager: AFNetworkReachabilityManager!
    private(set) var status: AFNetworkReachabilityStatus!
    private var observers: NSMutableArray?
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    
    /// Instance
    static var sharedInstance = ReachabilityService()
    
    
    override init() {
        super.init()
        
        self.observers = NSMutableArray()
    }
    
    
    // MARK: - Observers methods
    
    
    open func addObserver(observer: ReachabilityServiceDelegate!) {
        if !(self.observers?.contains(observer))! {
            self.observers?.add(observer)
        }
    }
    
    
    open func removeObserver(observer: ReachabilityServiceDelegate!) {
        if (self.observers?.contains(observer))! {
            self.observers?.remove(observer)
        }
    }
    
    
    open func notifyAllObserversAboutConnectToInternet() {
        let observersArray = self.observers
        
        for delegate in observersArray! {
            let dg = delegate as! ReachabilityServiceDelegate
            dg.didConnectToInternet()
        }
    }
    
    
    // MARK: - Tools 
    
    
    open func startChecking() {
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        self.status = AFNetworkReachabilityManager.shared().networkReachabilityStatus
        
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status: AFNetworkReachabilityStatus) in
            
            if status != .notReachable && self.status == .notReachable {
                self.notifyAllObserversAboutConnectToInternet()
            }
            
            self.status = status
        }
    }
    
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
}

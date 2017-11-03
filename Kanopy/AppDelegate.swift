//
//  AppDelegate.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit
import Fabric
import Crashlytics
import FBSDKCoreKit
import AVFoundation
import GoogleCast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GCKLoggerDelegate {

    var window: UIWindow?
    var mainScenario: MainScenario!
    public var kReceiverAppID: String = "25FC68EB";

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Implement Crashlytics service
        Fabric.with([Crashlytics.self])
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Initialize GoogleCast Context
        let options = GCKCastOptions(receiverApplicationID: kReceiverAppID)
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().defaultExpandedMediaControlsViewController.setButtonType(.custom, at: 2)
        let stopButton = UIButton.init(type: .custom)
        stopButton.sd_setImage(with: URL.init(string: "http://www.kanopystreaming.com/chromecast/assets/stop_icon.png"), for: .normal)
        stopButton.addTarget(self, action:#selector(self.buttonStopClicked), for: .touchUpInside)
        GCKCastContext.sharedInstance().defaultExpandedMediaControlsViewController.setCustomButton(stopButton, at: 2)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        window?.clipsToBounds = true
        let logFilter = GCKLoggerFilter()
        let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager", "GCKCastChannel",
                            "GCKMediaControlChannel", "GCKUICastButton", "GCKUIMediaController", "NSMutableDictionary"]
        logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        // Show window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()

        self.mainScenario = MainScenario(window: self.window)
        
        // Run main scenario
        self.mainScenario?.start()
        
        return true
    }
    
    func buttonStopClicked() {
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.stop()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        RefreshService.sharedInstance.notifyAboutAppWillEnterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options) || GIDSignIn.sharedInstance().handle(url,
                                                                                                                                            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                                                                                                            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return OrientationService.sharedInstance.orientation()
    }
}


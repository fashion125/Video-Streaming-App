//
//  MainScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/13/17.
//
//

import UIKit

class MainScenario: Scenario, ShelvesScenarioDelegate, SettingsScenarioDelegate, SearchScenarioDelegate, SubjectsScenarioDelegate, WatchlistScenarioDelegate, UITabBarControllerDelegate {

    open private(set) var window: UIWindow!
    
    private(set) var tabBarVC: UITabBarController!
    
    private(set) var homeScenario: HomeScenario!
    private(set) var settingsScenario: SettingsScenario!
    private(set) var searchScenario: SearchScenario!
    private(set) var subjectsScenario: SubjectsScenario!
    private(set) var watchlistScenario: WatchlistScenario!
    
    
    // MARK: - Init methods 
    
    
    init(window: UIWindow!) {
        super.init()
        self.window = window
    }
    
    
    // MARK: - 
    
    
    override func start() {
        if !AuthService.sharedInstance.isAuthorized() {
            self.makeTabBarController()
        } else {
            self.makeTabBarControllerForAuthorized()
        }
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: - Make tab bar controller 
    
    
    private func makeTabBarController() {
        
        self.tabBarVC = UITabBarController()
        
        self.createHomeScenario()
        self.createSettingsScenario()
        self.createSearchScenario()
        self.createSubjectsScenario()
        
        let viewControllers: Array<UIViewController> = [self.searchScenario.searchVCNC,
                                                        self.homeScenario.homeVCNC,
                                                        self.subjectsScenario.subjectsVCNC,
                                                        self.settingsScenario.settingsVCNC]
        
        self.tabBarVC.setViewControllers(viewControllers, animated: false)
        
        self.window?.rootViewController = self.tabBarVC
        self.window.makeKeyAndVisible()
        
        AuthService.sharedInstance.getSessionToken(completion: { 
            self.homeScenario.start()
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.tabBarVC)
        }
    }
    
    
    private func makeTabBarControllerForAuthorized() {
        self.tabBarVC = UITabBarController()
        
        self.createHomeScenario()
        self.createSettingsScenario()
        self.createSearchScenario()
        self.createSubjectsScenario()
        self.createWatchlistScenario()
        
        let viewControllers: Array<UIViewController> = [self.searchScenario.searchVCNC,
                                                        self.homeScenario.homeVCNC,
                                                        self.watchlistScenario.watchlistVCNC,
                                                        self.subjectsScenario.subjectsVCNC,
                                                        self.settingsScenario.settingsVCNC]
        
        self.tabBarVC.setViewControllers(viewControllers, animated: false)
        
        self.window?.rootViewController = self.tabBarVC
        self.window.makeKeyAndVisible()
        
        AuthService.sharedInstance.getSessionToken(completion: {
            self.homeScenario.start()
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.tabBarVC)
        }
    }
    
    
    private func createHomeScenario() {
        self.homeScenario = HomeScenario.init(rootVC: self.tabBarVC, delegate: self)
    }
    
    
    private func createSettingsScenario() {
        self.settingsScenario = SettingsScenario.init(rootVC: self.tabBarVC, delegate: self)
    }
    
    
    private func createSearchScenario() {
        self.searchScenario = SearchScenario.init(rootVC: self.tabBarVC, delegate: self)
    }
    
    
    private func createSubjectsScenario() {
        self.subjectsScenario = SubjectsScenario.init(rootVC: self.tabBarVC, delegate: self)
    }
    
    
    private func createWatchlistScenario() {
        self.watchlistScenario = WatchlistScenario.init(rootVC: self.tabBarVC, delegate: self)
    }
    
    
    // MARK: - SettingsScenarioDelegate methods 
    
    
    func didUpdateUser(settingScenario: SettingsScenario!) {
        self.start()
    }
    
    
    // MARK: - 
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}

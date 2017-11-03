//
//  HomeScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/13/17.
//
//

import UIKit

protocol HomeScenarioDelegate {
    
}

class HomeScenario: ShelvesScenario {
    
    
    // MARK: - Init methods 
    
    
    override init(rootVC: UITabBarController!, delegate: ShelvesScenarioDelegate) {
        super.init(rootVC: rootVC, delegate: delegate)
        
        self.createHomeVC()
    }
    
    
    // MARK: -
    
    
    override func start() {
        super.start()
        
        self.rootVC.selectedIndex = 1
        self.loadHomePage()
    }
    
    
    override func stop() {
        super.stop()
    }
    
    
    // MARK: -
    
    
    private func createHomeVC() {
        self.homeVC = HomeVC.init(delegate: self)
        self.homeVCNC = UINavigationController.init(rootViewController: self.homeVC)
        self.homeVCNC.tabBarItem = UITabBarItem.init(title: "HOME".localized, image: nil, tag: 0)
        
        self.homeVC.showLoadIndicator()
    }
    
    
    private func loadHomePage() {
        
        VideoService.sharedInstance.displays(completion: { (shelves: [ShelfModel], categories: [CategoryModel], user: UserModel) in
            
            var cs = [CategoryModel]()
            cs.append(CategoryModel.init(termID: "0", vocabularyID: "0", name: "MAIN".localized, vocabulary: "main", subcategory: nil))
            cs.append(contentsOf: categories)
            
            self.shelves = shelves
            self.categories = cs
            
            let vm = HomeVM.init(shelves: shelves, categories: self.categories, delegate: self, currentSelectedCategory: cs.first?.termID)
            self.homeVC.update(vm)
            self.homeVC.updateFocusIfNeeded()
            self.homeVC.setNeedsFocusUpdate()
            
            self.currentCategory = cs.first?.termID
            
            self.homeVC.hideLoadIndicator()
            
            
        }, cacheCompletion: { (shelves: [ShelfModel], categories: [CategoryModel], user: UserModel) in
            
        }) { (error: ErrorModel) in
            self.homeVC.hideLoadIndicator()
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.homeVCNC)
        }
    }
}

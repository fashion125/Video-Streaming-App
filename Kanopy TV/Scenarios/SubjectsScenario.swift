//
//  SubjectsScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/28/17.
//
//

import UIKit

protocol SubjectsScenarioDelegate {
    
}

class SubjectsScenario: ShelvesScenario, SubjectsVCDelegate, VideoServiceDelegate, GenericVCDelegate {

    private(set) var subjectsVC: SubjectsVC!
    private(set) var subjectsVCNC: UINavigationController!
    
    private(set) var topCategories: Array<CategoryModel>!
    
    
    // MARK: - Init methods
    
    
    override init(rootVC: UITabBarController!, delegate: ShelvesScenarioDelegate) {
        super.init(rootVC: rootVC, delegate: delegate)
        
        self.categories = [CategoryModel]()
        self.topCategories = [CategoryModel]()
        
        VideoService.sharedInstance.addObserver(observer: self)
        
        self.createSubjectsVC()
    }
    
    
    // MARK: -
    
    
    override func start() {
        
        self.didLoadHomePageData(categories: self.topCategories)
    }
    
    
    override func stop() {
        VideoService.sharedInstance.removeObserver(observer: self)
    }
    
    
    // MARK: -
    
    
    private func createSubjectsVC() {
        self.subjectsVC = SubjectsVC.init(delegate: self)
        self.subjectsVC.genericVCDelegate = self
        self.subjectsVCNC = UINavigationController.init(rootViewController: self.subjectsVC)
        self.subjectsVCNC.tabBarItem = UITabBarItem.init(title: "SUBJECTS".localized, image: nil, tag: 1)
    }
    
    
    open func updateCategories(categories: Array<CategoryModel>!) {
        let vm = SubjectsVM.init(delegate: self, items: self.topCategories)
        self.subjectsVC.updateViewModel(vm)
    }
    
    
    // MARK: -
    
    
    private func showSubjectVC(category: CategoryModel!) {
        
        self.categories = category.subcategory
        
        self.currentCategory = category.subcategory?.first?.termID
        
        self.homeVC = HomeVC.init(delegate: self)
        self.subjectsVCNC.pushViewController(self.homeVC, animated: true)
        
        self.loadForAnother(category: category.subcategory?.first)
    }
    
    
    private func loadShelf(shelfID: String!) {
        
    }
    
    
    // MARK: - SubjectsVCDelegate methods 
    
    
    func didChooseCategoryModel(categoryModel: CategoryModel!) {
        self.showSubjectVC(category: categoryModel)
    }
    
    
    // MARK: - GenericVCDelegate methods 

    
    func viewWillAppear() {
        self.start()
    }
    
    
    // MARK: - VideoServiceDelegate methods 
    
    
    func didLoadHomePageData(categories: Array<CategoryModel>) {
        
        self.topCategories = categories
        
        if self.subjectsVC.tableView != nil {
            self.updateCategories(categories: categories)
        }
    }
}

//
//  HomeScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit
import MBProgressHUD

protocol HomeScenarioDelegate {
    
    /** Method is call when user sign out in app */
    func didSignOut()
    
    func didChangeMembership()
}


class HomeScenario: GenericScenario, HomeVCDelegate, MenuVCDelegate, CategoryVCDelegate, MenuCommandDelegate, SettingsScenarioDelegate, AlertViewDelegate, MyPlaylistScenarioDelegate, ProfileScenarioDelegate, ReachabilityServiceDelegate, LinkYourRokuVCDelegate, RefreshServiceDelegate {
    
    
    var menuVC: MenuVC?
    var homeVC: HomeVC?
    
    var categoryVC: CategoryVC?
    var playlistVC: PlaylistVC?
    var subShelfVC: CategoryVC?
    var linkYourRokuVC: LinkYourRokuVC!
    
    private(set) var playlistScenario: MyPlaylistScenario!
    
    var delegate: HomeScenarioDelegate?
    
    private var currentOpenKey: String! = ""
    
    
    // MARK: - Init method
    
    
    init(nvc: MenuNavigationController!) {
        super.init()
        self.nvc = nvc
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func start() {
        
        ReachabilityService.sharedInstance.startChecking()
        ReachabilityService.sharedInstance.addObserver(observer: self)
        
        RefreshService.sharedInstance.addObserver(observer: self)
        
        self.updateMenuScreen()
        self.showHomeScreen()
    }
    
    
    override func stop() {
        RefreshService.sharedInstance.removeObserver(observer: self)
    }
    
    
    // MARK: - Update menu methods
    
    
    /** Method create menu view controller and load data about categories */
    func updateMenuScreen() {
        
        self.menuVC = MenuVC(delegate: self)
        self.nvc.updateMenuVC(with: self.menuVC)
        
        self.menuVC?.showLoadIndicator()
    }
    
    
    // MARK: - Show screen methods
    
    
    /** Method show home view controller */
    private func showHomeScreen() {
        
        /// Create and show Home screen
        self.homeVC = HomeVC(delegate: self)
        self.homeVC?.searchDelegate = self
        self.changeRootController(with: self.homeVC, animated: false)
        self.currentOpenKey = MenuActionKey.homeKey
        
        homeVC?.showLoadIndicator()
    }
    
    
    func loadHomePage() {
        
        VideoService.sharedInstance.displays(completion: { (shelfs: [ShelfModel], categories: [CategoryModel], userModel: UserModel) in
            AuthService.sharedInstance.updateUser(userModel)
            self.updateMenuVC(categories: categories)
            self.updateHomeVC(shelfs: shelfs)
        }, cacheCompletion: { (shelfs: [ShelfModel], categories: [CategoryModel], userModel: UserModel) in
            self.updateMenuVC(categories: categories)
            self.updateHomeVC(shelfs: shelfs)
        }) { (error: ErrorModel) in
            self.homeVC?.hideLoadIndicator()
            self.showError(error: error)
        }
    }
    
    
    func updateMenuVC(categories: [CategoryModel]!) {
        
        let menuVM = MenuVM.init(categories: categories,
                                 menuCommandDelegate: self, selectedKey: self.currentOpenKey)
        
        self.menuVC?.update(with: menuVM)
        self.menuVC?.hideLoadIndicator()
        
        self.updatePlaylists()
    }
    
    
    func updatePlaylists() {
        
        PlaylistService.sharedInstance.myPlaylist(completion: { (playlists: Array<PlaylistModel>) in
            
            let menuVM = self.menuVC?.viewModel
            menuVM?.updatePlaylists(playlists: playlists)
            self.menuVC?.update(with: menuVM)
            
        }) { (error: ErrorModel) in
            
            let menuVM = self.menuVC?.viewModel
            menuVM?.updatePlaylists(playlists: [])
            self.menuVC?.update(with: menuVM)
        }
    }
    
    
    func updateHomeVC(shelfs: [ShelfModel]) {
        
        let vm = HomeVM.init(shelves: shelfs, delegate: self)
        self.homeVC?.update(with: vm)
        self.homeVC?.hideLoadIndicator()
    }
    
    
    func showError(error: ErrorModel!) {
        self.menuVC?.hideLoadIndicator()
        self.homeVC?.hideLoadIndicator()
        UIAlertController.showAlert(title: "ERROR".localized,
                                    message: error.messageError!,
                                    fromVC: self.homeVC!)
    }
    
    
    /** Method show category view controller 
     - parameter category: category model wich in store all info about category
     */
    func showCategoryScreen(_ category: CategoryModel!) {
        
        self.categoryVC = CategoryVC.init(with: category.name, delegate: self, isShowBackButton: false)
        self.categoryVC?.searchDelegate = self
        self.changeRootController(with: self.categoryVC, animated: false)
        
        weak var weakSelf = self.categoryVC
        
        self.categoryVC?.showLoadIndicator()
        
        ShelvesService.sharedInstance.shelves(categoryID: category.termID,
            completion: { (shelves: Array<ShelfModel>) in
                
                if weakSelf != nil {
                    let categoryVM = CategoryVM.init(shelves: shelves, delegate: self, category: category, currentVC: weakSelf)
                    weakSelf?.update(with: categoryVM)
                    
                    weakSelf?.hideLoadIndicator()
                }
                
        }) { (error: ErrorModel) in
            
            if weakSelf != nil {
                weakSelf?.hideLoadIndicator()
                UIAlertController.showAlert(title: "ERROR".localized, message: error.messageError!, fromVC: weakSelf!)
            }
            
        }
    }
    
    
    func showSubCategoryScreen(_ shelf: ShelfModel!) {
        
        self.subShelfVC = nil
        
        let category = self.categoryVC?.viewModel.currentCategory.getSubcategoryWithTitle(title: shelf.title)
        
        if category == nil {
            return
        }
        
        self.subShelfVC = CategoryVC.init(with: shelf.title, delegate: self, isShowBackButton: true)
        self.subShelfVC?.searchDelegate = self
        self.categoryVC?.navigationController?.pushViewController(self.subShelfVC!, animated: true)
        self.subShelfVC?.showLoadIndicator()
        
        ShelvesService.sharedInstance.shelves(categoryID: category?.termID,
                                              completion: { (shelves: Array<ShelfModel>) in
                                                
                                                let categoryVM = CategoryVM.init(shelves: shelves, delegate: self, category: category, currentVC: self.subShelfVC)
                                                self.subShelfVC?.update(with: categoryVM)
                                                self.subShelfVC?.hideLoadIndicator()
        }) { (error: ErrorModel) in
            self.subShelfVC?.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized, message: error.messageError!, fromVC: self.subShelfVC!)
        }
    }
    
    
    func showSettingsScreen() {
        
        let settingsScenario = SettingsScenario.init(nvc: self.nvc,
                                                     delegate: self)
        settingsScenario.start()
    }
    
    
    func showPlaylistScreen(_ playlistModel: PlaylistModel!) {
        
        self.playlistScenario = MyPlaylistScenario.init(nvc: self.nvc,
                                                       delegate: self,
                                                       playlistModel: playlistModel)
        self.playlistScenario.start()
    }
    
    
    func showUserProfileScreen() {
        
        let profileScenario = ProfileScenario.init(nvc: self.nvc,
                                                   delegate: self)
        profileScenario.start()
    }
    
    
    func autologinTo(hashtag: String, completion: @escaping (() -> Void), failure: @escaping (() -> Void)) {
        let userID = AuthService.sharedInstance.user?.userID
        let destination = "user/" + userID! + "/identities"
        
        _ = AuthService.sharedInstance.getAutologinUrl(userID: userID, destination: destination, hashtag: hashtag,
                                                       completion: { (url: String) in
                                                        if #available(iOS 10.0, *) {
                                                            UIApplication.shared.open(NSURL(string: url)! as URL)
                                                        } else {
                                                            UIApplication.shared.openURL(URL(string: url)!)
                                                        }
                                                        completion()
        }, failure: { (error: ErrorModel) in
            failure()
        })
    }
    
    
    func updateLinkYourRokuVM() {
        let linkYourRokuVM = LinkYourRokuVM.init(title: "LINK_YOUR_ROKU".localized, delegate: self)
        self.linkYourRokuVC.update(with: linkYourRokuVM)
    }
    
    
    // MARK: - Tools
    
    
    /** Method change current root view controller
     - parameter viewController: new root view controller
     - parameter animater: is animated change
     */
    private func changeRootController(with viewController: GenericVC!, animated: Bool!) {
        self.nvc.setViewControllers([viewController], animated: animated)
    }
    
    
    /** Method check is equal new key with current key */
    private func isCurrentScreen(key: String!) -> Bool {
        return self.currentOpenKey == key
    }
    
    
    func updateCurrentOpenKey(_ newKey: String!) {
        self.currentOpenKey = newKey
    }
    
    
    // MARK: - HomeVCDelegate methods
    
    
    func didPressToItem(item: ItemModel!) {
        self.openItemScreen(parentVC: self.homeVC, item: item)
    }
    
    
    func didPressToAllSeeButton(shelf: ShelfModel!) {
        self.openSubCategoryScreen(parentVC: self.homeVC, shelf: shelf)
    }
    
    
    func loadItems(shelfCellModel: ShelfCellModel!, offset: Int!) {
        
        ShelvesService.sharedInstance.shelfItems(shelfID: shelfCellModel.shelf.shelfID,
                                                 offset: offset,
                                                 limit: Constants.shelfItemsLimit,
                                                 completion: { (items: Array<ItemModel>) in
                                                    
                                                    shelfCellModel.updateShelfItems(items: items)

                                                        self.homeVC?.update(with: self.homeVC?.viewModel)
                                                    
        }) { (error: ErrorModel) in
            shelfCellModel.updateShelfItems(items: [])
        }
    }
    
    
    // MARK: - CategoryVCDelegate methods
    
    
    func didPressToItemOnCategoryScreen(item: ItemModel!, categoryVC: CategoryVC!) {
        self.openItemScreen(parentVC: categoryVC, item: item)
    }
    
    
    func didPressToAllSeeButtonOnCategoryScreen(shelf: ShelfModel!, categoryVC: CategoryVC!) {
        
        if categoryVC == self.categoryVC {
            self.showSubCategoryScreen(shelf)
        } else {
            self.openSubCategoryScreen(parentVC: self.categoryVC, shelf: shelf)
        }
    }
    
    
    func loadItemsOnCategoryScreen(shelfCellModel: ShelfCellModel!, offset: Int!, categoryVC: CategoryVC!) {
        
        weak var shelfCM = shelfCellModel
        
        ShelvesService.sharedInstance.shelfItems(shelfID: shelfCM?.shelf.shelfID,
                                                 offset: offset,
                                                 limit: Constants.shelfItemsLimit,
                                                 completion: { (items: Array<ItemModel>) in
                                                    shelfCM?.updateShelfItems(items: items)
                                                    
                                                    categoryVC.update(with: categoryVC.viewModel)
        }) { (error: ErrorModel) in
            shelfCM?.updateShelfItems(items: [])
        }
    }
    
    
    func didPressToBackButton(categoryVC: CategoryVC!) {
        categoryVC.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - ProfileScenarioDelegate methods 
    
    
    func didShowHomePageScreen(_ profileScenario: ProfileScenario!) {
        self.nvc.popViewController(animated: true)
        self.delegate?.didChangeMembership()
//        self.showHomeScreen()
//        self.loadHomePage()
    }

    
    
    // MARK: - MenuCommandDelegate methods 
    
    
    func didShowHomePageScreen() {
    
        self.nvc.sideMenu?.hideSideMenu(completion: {
            
            if !self.isCurrentScreen(key: MenuActionKey.homeKey) {
                self.showHomeScreen()
                self.loadHomePage()
            }
            
            self.updateCurrentOpenKey(MenuActionKey.homeKey)
        })
    }
    
    
    func didShowCategoryScreen(_ categoryModel: CategoryModel!) {
        
        self.nvc.sideMenu?.hideSideMenu(completion: {
            
            let key = MenuActionKey.categoryKey + categoryModel.termID
            
            if !self.isCurrentScreen(key: key) {
                self.showCategoryScreen(categoryModel)
            }
            
            self.updateCurrentOpenKey(key)
        })
    }
    
    
    func didShowPlaylistScreen(_ playlistModel: PlaylistModel!) {
        
        self.nvc.sideMenu?.hideSideMenu(completion: {
            
            let key = MenuActionKey.playlistKey + playlistModel.playlistID
            
            if !self.isCurrentScreen(key: key) {
                self.showPlaylistScreen(playlistModel)
            }
            
            self.updateCurrentOpenKey(key)
        })
    }
    
    
    func didShowSettingsScreen() {
        self.nvc.sideMenu?.hideSideMenu {
            
            //if !self.isCurrentScreen(key: MenuActionKey.settingsKey) {
                self.showSettingsScreen()
            //}
            
            //self.updateCurrentOpenKey(MenuActionKey.settingsKey)
        }
    }
    
    
    func didPressToSignOutButton() {
        
        self.nvc.sideMenu?.hideSideMenu {
            
            let alertView = AlertView.init(titleText: "SIGN_OUT_MESSAGE".localized,
                                           parentVC: self.nvc.topViewController,
                                           delegate: self)
            alertView.show()
        }
    }
    
    
    func didPressToSignInButton() {
        self.nvc.sideMenu?.hideSideMenu {
            RequestService.sharedInstance.notifyAllObserversAboutUnauthorized()
        }
    }
    
    
    func didPressToUserButton() {
        
        self.nvc.sideMenu?.hideSideMenu {
            
            //if !self.isCurrentScreen(key: MenuActionKey.userKey) {
                self.showUserProfileScreen()
            //}
            
            //self.updateCurrentOpenKey(MenuActionKey.userKey)
        }
    }
    
    
    func didPressLinkYourRoku() {
        self.nvc.sideMenu?.hideSideMenu {
            
            self.linkYourRokuVC = LinkYourRokuVC.init(delegate: self)
            self.updateLinkYourRokuVM()
            
            self.nvc?.pushViewController(self.linkYourRokuVC, animated: true)
        }
    }
    
    
    // MARK: - LinkYourRokuVCDelegate methods
    
    
    func didPressToBackButton(linkYourRokuVC: LinkYourRokuVC!) {
        self.nvc?.popViewController(animated: true)
    }
    
    
    func didValidCodeRoku(code: String!) {
        if code.range(of: "^[a-zA-Z0-9]{6}$", options: .regularExpression) == nil {
            UIAlertController.showAlert(title: "CODE_SHOULD_BE_ALPHANUMERICAL_AND_SIX_CHARACTERS_LONG".localized, message: "", fromVC: self.linkYourRokuVC)
        } else {
            AuthService.sharedInstance.activateAuthcode(authcode: code, completion: {
                let alertController = UIAlertController(title: "ROKU_SUCCESSFULLY_LINKED".localized, message: "", preferredStyle:UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler:
                    { (action: UIAlertAction!) -> Void in
                        self.didPressToBackButton(linkYourRokuVC: self.linkYourRokuVC)
                }))
                self.linkYourRokuVC.present(alertController, animated: true, completion: nil)
            }, failure: { (error) in
                UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.linkYourRokuVC)
            })
        }
    }
    
    
    // MARK: - AlertViewDelegate methods
    
    
    func didPressToConfirmButton(alertView: AlertView!) {
        
        AuthService.sharedInstance.unauthorized()
        alertView.hide()
        
        self.updateMenuVC(categories: self.menuVC?.viewModel.categories)
        self.delegate?.didSignOut()
    }
    
    
    func didPressToCloseButton(alertView: AlertView!) {
        alertView.hide()
    }
    
    
    func didPressToCancelButton(alertView: AlertView!) {
        alertView.hide()
    }
    
    
    // MARK: - ReachibilityServiceDelegate
    
    
    func didConnectToInternet() {
        AuthService.sharedInstance.getSessionToken(completion: { 
            self.loadHomePage()
        }) { (error: ErrorModel) in
            self.showError(error: error)
        }
        
    }
    
    
    // MARK: - RefreshServiceDelegate
    
    
    /** This method is call when user enter foreground app */
    func appWillEnterForeground() {
        
    }
    
    /** This method is called when the Side Menu should be refreshed */
    func refreshSideMenu() {
//        DispatchQueue.global().async {
            VideoService.sharedInstance.displays(completion: { (shelfs: [ShelfModel], categories: [CategoryModel], userModel: UserModel) in
                AuthService.sharedInstance.updateUser(userModel)
                self.updateMenuVC(categories: categories)
            }, cacheCompletion: { (shelfs: [ShelfModel], categories: [CategoryModel], userModel: UserModel) in
                self.updateMenuVC(categories: categories)
            }) { (error: ErrorModel) in
                self.showError(error: error)
            }
//        }
    }
}

//
//  ResetPasswordVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/19/17.
//
//

import UIKit

protocol ResetPasswordVCDelegate {
    
    /** Method is call when user tap to reset password button */
    func didPressToResetPasswordButton()
    
    /** Method is call when user tap to back button */
    func didPressToBackButton(resetPasswordVC: ResetPasswordVC!)
}

class ResetPasswordVC: GenericTVC {

    private(set) var delegate: ResetPasswordVCDelegate!
    private(set) var viewModel: ResetPasswordVM!
    
    
    // MARK: - Init methods 
    
    
    init(delegate: ResetPasswordVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.addChromecastIfPossible = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTitle(with: "RESET_PASSWORD".localized)
        self.showBackButton()
        
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.updateForDefault()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AuthService.sharedInstance.unauthorized()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func scrollToCell() {
        let count = self.viewModel.sections[0].cellModels.count
        let indexPath = IndexPath.init(row: (count-1), section: 0)
        
        self.tableView.scrollToRow(at: indexPath,
                                   at: .top,
                                   animated: false)
    }
    
    
    override func showLoadIndicator() {
        self.viewModel.showLoadCellModel()
        self.updateViewModel(self.viewModel)
    }
    
    
    override func hideLoadIndicator() {
        self.viewModel.showResetButton()
        self.updateViewModel(self.viewModel)
    }
    
    
    override func updateTableViewFrame() {
        self.tableView.frame = CGRect(x: (UIScreen.main.bounds.width - SizeStrategy.authTableViewWidth())/2,
                                      y: self.view.bounds.origin.y + self.topMargin ,
                                      width: SizeStrategy.authTableViewWidth(),
                                      height: self.view.bounds.size.height - self.kbHeight - self.topMargin)
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if self.viewModel != nil {
            self.viewModel.generateSections()
        }
        
        self.updateViewModel(self.viewModel)
    }
    
    
    // MARK: - Update methods 
    
    
    /** Method update navigation bar */
    func updateNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        /// Change backgorund for navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        /// Change bar tint and tint color
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.navBarTintColor()
        self.navigationController?.view.backgroundColor = .clear
        
        /// is transculent is false
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    /** This method create default view model for current view controller */
    func updateForDefault() {
        
        let defaultVM = ResetPasswordVM.init(delegate: self.delegate)
        self.updateViewModel(defaultVM)
    }
    
    
    // MARK: - Update ViewModel method
    
    
    /** This method update view model and reload data for table
     - parameters:
        - viewModel: New view model object
     */
    func updateViewModel(_ viewModel: ResetPasswordVM!) {
        
        self.viewModel = viewModel
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.registerCellTypes()
        self.tableView.reloadData()
    }
    
    
    // MARK: - Get data method 
    
    
    /** Method return entered email value from view model */
    open func email() -> String {
        return self.viewModel.emailCM.value
    }
    
    
    // MARK: -
    
    
    override func didPressToBackButton() {
        self.delegate.didPressToBackButton(resetPasswordVC: self)
    }
}

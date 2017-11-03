//
//  AuthVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

protocol AuthVCDelegate {
    
    func didPressToFBSignInButton()
    
    func didPressToFBSignUpButton()
    
    func didPressToGoogleSignInButton()
    
    func didPressToGoogleSignUpButton()
    
    func didPressToEmailSignInButton()
    
    func didPressToEmailSignUpButton()
    
    func didPressToHaveAlreadyAccountButton()
    
    func didPressToDontHaveAccountButton()
    
    func didPressToForgotPasswordButton()
    
    func didPressToTermsButton()
    
    func didPressToPrivacyPolicyButton()
    
    func didPressToBackButton(authVC: AuthVC!)
}

class AuthVC: GenericTVC, OrientationServiceDelegate {

    private(set) var delegate: AuthVCDelegate?
    private(set) var viewModel: AuthVM!
    
    
    // MARK: - Init methods 
    
    
    init(delegate: AuthVCDelegate?) {
        
        super.init()
        
        self.delegate = delegate
        self.addChromecastIfPossible = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.showsVerticalScrollIndicator = false
        
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.showBackButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OrientationService.sharedInstance.addObserver(observer: self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        OrientationService.sharedInstance.removeObserver(observer: self)
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if self.viewModel != nil {
            self.viewModel.generateSections()
        }
        
        self.update(with: self.viewModel)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func scrollToCell() {
        let count = self.viewModel.sections[0].cellModels.count
        let indexPath = IndexPath.init(row: (count-1), section: 0)
        
        self.tableView.scrollToRow(at: indexPath,
                                   at: .top,
                                   animated: false)
    }
    
    
    override func updateTableViewFrame() {
        self.tableView.frame = CGRect(x: (UIScreen.main.bounds.width - SizeStrategy.authTableViewWidth())/2,
                                      y: self.view.bounds.origin.y + self.topMargin ,
                                      width: SizeStrategy.authTableViewWidth(),
                                      height: self.view.bounds.size.height - self.kbHeight - self.topMargin)
    }
    
    
    // MARK: - 
    
    
    open func updateForSignIn() {
        let signInVM = SignInVM.init(authVCDelegate: self.delegate)
        self.update(with: signInVM)
        self.showTitle(with: "SIGN_IN".localized)
    }
    
    
    open func updateForSignUp() {
        let signUpVM = SignUpVM.init(authVCDelegate: self.delegate)
        self.update(with: signUpVM)
        self.showTitle(with: "SIGN_UP".localized)
    }
    
    
    open func authDataModel() -> AuthDataModel {
        
        let authData = AuthDataModel.init(firstName: self.viewModel.firstName(),
                                          lastName: self.viewModel.lastName(),
                                          email: self.viewModel.email(),
                                          password: self.viewModel.password())
        
        return authData
    }
    
    
    override func showLoadIndicator() {
        self.viewModel.showLoadCellModel()
        self.update(with: self.viewModel)
    }
    
    
    override func hideLoadIndicator() {
        self.viewModel.showAuthButton()
        self.update(with: self.viewModel)
    }
    
    
    func update(with viewModel: AuthVM!) {
        
        self.viewModel = viewModel
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.registerCellTypes()
        self.tableView.reloadData()
    }
    
    
    // MARK: -
    
    
    override func didPressToBackButton() {
        self.delegate?.didPressToBackButton(authVC: self)
    }
    
    
    // MARK: - Orientation service delegate methods 
    
    
    func didChangeOrientation() {
        
    }
}

//
//  LoginScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/6/17.
//
//

import UIKit
import FBSDKLoginKit

protocol LoginScenarioDelegate {
    
    /** Method is call when login scenario is finished */
    func stopScenario(_ loginScenario: LoginScenario!)
    
    func closeScenario(_ loginScenario: LoginScenario!)
}


class LoginScenario: Scenario, AuthVCDelegate, GIDSignInDelegate, GIDSignInUIDelegate, ActivationScenarioDelegate, ResetPasswordVCDelegate, AuthServiceInjected, SocialNetworkingInjected {
    
    private(set) var delegate: LoginScenarioDelegate?
    private(set) var nvc: MenuNavigationController!
    
    var authVC: AuthVC!
    var resetPasswordVC: ResetPasswordVC!
    
    var activationScenario: ActivationScenario!
    
    typealias GoogleAnalyticsCompletion = (String) -> Void
    private(set) var googleAuthCompletion: GoogleAnalyticsCompletion?
    
    
    // MARK: - Init methods 
    
    
    init(nvc: MenuNavigationController!, delegate: LoginScenarioDelegate?) {
        super.init()
        
        self.delegate = delegate
        self.nvc = nvc
    }
    
    
    // MARK: -
    
    
    /** Start the current scenario. */
    override func start() {
        self.showSignInScreen()
    }
    

    /** Stop the current scenario. */
    override func stop() {
        self.delegate?.stopScenario(self)
    }
    
    
    func start(logIn: Bool!) {
        if (logIn) {
            self.showSignInScreen()
        } else {
            self.showSignUpScreen()
        }
    }
    
    
    // MARK: -
    
    
    private func showSignInScreen() {
        
        self.authVC = AuthVC.init(delegate: self)
        
        let navVC = MenuNavigationController.init()
        navVC.viewControllers = [self.authVC]
        
        self.nvc.viewControllers.first?.present(navVC, animated: true, completion: nil)
        self.authVC.updateForSignIn()
    }
    
    
    private func showSignUpScreen() {
        
        self.authVC = AuthVC.init(delegate: self)
        
        let navVC = MenuNavigationController.init()
        navVC.viewControllers = [self.authVC]
        
        self.nvc.viewControllers.first?.present(navVC, animated: true, completion: nil)
        self.authVC.updateForSignUp()
    }
    
    
    func startActivationScenario(withStatusModel statusModel: StatusActivationModel!) {
        
        self.activationScenario = ActivationScenario.init(authVC: self.authVC,
                                                         delegate: self,
                                                         comingFromLoginScenario: true)
        self.activationScenario.start(withStatusModel: statusModel)
    }
    
    
    private func checkActivation(_ completion: @escaping (() -> Void)) {
        
        let userID = AuthService.sharedInstance.user?.userID
        
        authService.checkStatusVerification(userID: userID!,
                                                           completion: { (statusModel: StatusActivationModel) in
                                                            
                                                            if statusModel.isVerifyEmail {
                                                                completion()
                                                                self.stop()
                                                                self.authVC.dismiss(animated: true, completion: nil)
                                                                
                                                            } else {
                                                                completion()
                                                                self.startActivationScenario(withStatusModel: statusModel)
                                                            }
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: error.titleError + " Login",
                                        message: error.messageError!,
                                        fromVC: self.authVC)
        }
    }
    
    
    // MARK: - Get session token method 
    
    
    /** This method get new session token for app
     - parameters:
        - completion: This block is call when user successfully get token
     */
    func getSessionToken(vc: GenericVC!, completion: @escaping () -> Void?) {
        
        authService.getSessionToken(completion: {
            
            completion()
            
        }) { (error: ErrorModel) in
            
            vc.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.authVC)
        }
    }
    
    
    // MARK: - Email auth methods 
    
    
    /** This method login user using email and password
     - parameters:
        - authDataModel: This object which in which store all info for sign in
     */
    func emailSignIn(_ authDataModel: AuthDataModel!) {
        
        self.getSessionToken(vc: self.authVC) { () -> Void? in
            self.authService.signIn(authData: authDataModel,
                                    completion: { (token: String) in
                                        
                                        self.checkActivation {
                                            self.authVC.updateForSignIn()
                                        }
                                        
            }) { (error: ErrorModel) in
                
                self.authVC.hideLoadIndicator()
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.authVC)
            }
        }
    }
    
    
    /** This method register new user using email and password
     - parameters:
     - authDataModel: This object which in which store all info for sign up
     */
    func emailSignUp(_ authDataModel: AuthDataModel!) {
        
        self.getSessionToken(vc: self.authVC) { () -> Void? in
            self.authService.signUp(authData: authDataModel,
                                    completion: { (token: String) in
                                        
                                        self.checkActivation {
                                            self.authVC.updateForSignUp()
                                        }
                                        
            }) { (error: ErrorModel) in
                self.authVC.hideLoadIndicator()
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.authVC)
            }
        }
    }
    
    
    // MARK: - Facebook auth methods
    
    
    /** This method get facebook access token for user
     - parameters:
        - completion: This block is call when user successfully get token
     */
    func getFacebookToken(completion: @escaping (String) -> Void?) {
        
        let fbManager = self.facebookManager
        fbManager.logOut()
        
        fbManager.logIn(withReadPermissions: ["public_profile", "email"], from: self.authVC) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            
            if result?.token == nil {
                self.authVC.hideLoadIndicator()
                //UIAlertController.showAlert(title: "ERROR".localized, message: "Can't load facebook token!", fromVC: self.authVC)
                
                return
            }
            
            if error == nil {
                completion((result?.token.tokenString)!)
            } else {
                self.authVC.hideLoadIndicator()
                //UIAlertController.showAlert(title: "ERROR".localized, message: (error?.localizedDescription)!, fromVC: self.authVC)
            }
        }
    }
    
    
    /** This method login user using facebook provider
     - parameters:
        - facebookToken: Token for facebook provider
     */
    func facebookSignIn(_ facebookToken: String!) {
        
        self.getSessionToken(vc: self.authVC) { () -> Void? in
            self.authService.signInWithSocial(provider: "facebook",
                                              token: facebookToken,
                                              completion: { (token: String) in
                                                
                                                self.checkActivation {
                                                    self.authVC.updateForSignIn()
                                                }
                                                
            }, failure: { (error: ErrorModel) in
                
                self.authVC.updateForSignIn()
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.authVC)
                
            })
        }
    }
    
    
    /** This method register new user using facebook provider 
     - parameters:
        - facebookToken: Token for facebook provider
     */
    func facebookSignUp(_ facebookToken: String!) {
        
        self.getSessionToken(vc: self.authVC) { () -> Void? in
            self.authService.singUpWithSocial(provider: "facebook",
                                              token: facebookToken,
                                              completion: { (token: String) in
                                                
                                                self.checkActivation {
                                                    self.authVC.updateForSignUp()
                                                }
                                                
            }, failure: { (error: ErrorModel) in
                self.authVC.updateForSignUp()
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.authVC)
            })
        }
    }
    
    
    // MARK: - Google auth methods 
    
    
    /** This method login user using google provider
     - parameters:
        - googleToken: Token for google provider
     */
    func googleSignIn(_ googleToken: String!) {
        
        self.getSessionToken(vc: self.authVC) { () -> Void? in
            self.authService.signInWithSocial(provider: "google",
                                              token: googleToken,
                                              completion: { (tkn: String) in
                                                
                                                self.checkActivation {
                                                    self.authVC.updateForSignIn()
                                                }
                                                
            }, failure: { (error: ErrorModel) in
                
                self.authVC.hideLoadIndicator()
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.authVC)
            })
        }
    }
    
    
    /** This method register new user using google provider
     - parameters:
        - googleToken: Token for google provider
     */
    func googleSignUp(_ googleToken: String!) {
        
        self.getSessionToken(vc: self.authVC) { () -> Void? in
            self.authService.singUpWithSocial(provider: "google",
                                              token: googleToken,
                                              completion: { (tkn: String) in
                                                
                                                self.checkActivation {
                                                    self.authVC.updateForSignUp()
                                                }
                                                
            }, failure: { (error: ErrorModel) in
                self.authVC.hideLoadIndicator()
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.authVC)
            })
        }
    }
    
    
    /** This method start google auth using GoogleSDK */
    func googleAuth() {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "33816451887-l57nbie3onclqe6kuqms78bvqrbcasbc.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "33816451887-2co02g20m4bcbn976u008kselldn3i3s.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // MARK: - GoogleSDKDelegate methods
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil && user.serverAuthCode != nil) {
            self.googleAuthCompletion!(user.authentication.accessToken)
        } else if (error != nil) {
            self.googleAuthCompletion!("")
            //UIAlertController.showAlert(title: "ERROR".localized, message: error.localizedDescription, fromVC: self.authVC)
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.authVC.present(viewController, animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.authVC.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Reset password method 
    
    
    /** This method reset password 
     - parameters:
        - email: Email for reset password
     */
    func resetPassword(_ email: String!) {
        
        self.getSessionToken(vc: self.resetPasswordVC) { () -> Void? in
            self.authService.resetPassword(email: email,
                                           completion: {
                                            
                                            self.resetPasswordVC.hideLoadIndicator()
                                            self.resetPasswordVC.navigationController?.popViewController(animated: true)
                                            
                                            UIAlertController.showAlert(title: "TITLE_PASSWORD_RESET_INSTRUCTIONS_SENT".localized,
                                                                        message: "DESCRIPTION_PASSWORD_RESET_INSTRUCTIONS_SENT".localized,
                                                                        fromVC: self.authVC.navigationController!)
                                            
            }, failure: { (error: ErrorModel) in
                
                self.resetPasswordVC.hideLoadIndicator()
                UIAlertController.showAlert(title: error.titleError,
                                            message: error.messageError!,
                                            fromVC: self.resetPasswordVC)
            })
        }
    }
    
    
    // MARK: - AuthVCDelegate methods
    
    
    func didPressToFBSignInButton() {
        
        self.authVC.showLoadIndicator()
        
        self.getFacebookToken { (facebookToken: String) -> Void? in
            self.facebookSignIn(facebookToken)
        }
    }
    
    
    func didPressToFBSignUpButton() {
        
        self.authVC.showLoadIndicator()
        
        self.getFacebookToken { (facebookToken: String) -> Void? in
            self.facebookSignUp(facebookToken)
        }
    }
    
    
    func didPressToEmailSignInButton() {
        
        self.authVC.showLoadIndicator()
        
        let authData = self.authVC.authDataModel()
        
        if !authData.verifyForSignIn() {
            
            self.authVC.hideLoadIndicator()
            UIAlertController.showAlert(title: "Not valid fields",
                                        message: "Please check all fields!", fromVC: self.authVC)
            return
        }
    
        self.emailSignIn(authData)
    }
    
    
    func didPressToEmailSignUpButton() {
        
        self.authVC.showLoadIndicator()
        
        let authData = self.authVC.authDataModel()
        
        if !authData.verifyForSignUp() {
            
            self.authVC.hideLoadIndicator()
            UIAlertController.showAlert(title: "TITLE_ERROR_FIELDS_SIGN_UP".localized,
                                        message: "DESCRIPTION_ERROR_FIELDS_SIGN_UP".localized, fromVC: self.authVC)
            
            return
        } else if !authData.verifyEmailForSignUp() {
            self.authVC.hideLoadIndicator()
            UIAlertController.showAlert(title: "TITLE_ERROR_EMAIL_SIGN_UP".localized,
                                        message: "DESCRIPTION_ERROR_EMAIL_SIGN_UP".localized, fromVC: self.authVC)
            
            return
        } else if !authData.verifyPasswordForSignUp() {
            self.authVC.hideLoadIndicator()
            UIAlertController.showAlert(title: "TITLE_ERROR_PASSWORD_SIGN_UP".localized,
                                        message: "DESCRIPTION_ERROR_PASSWORD_SIGN_UP".localized, fromVC: self.authVC)
            
            return
        }
        
        self.emailSignUp(authData)
    }
    
    
    func didPressToGoogleSignInButton() {
        
        self.authVC.showLoadIndicator()
        
        self.googleAuthCompletion = { googleToken in
            
            if !(googleToken.characters.count > 0) {
                self.authVC.hideLoadIndicator()
                return
            }
            
            self.googleSignIn(googleToken)
        }
        
        self.googleAuth()
    }
    
    
    func didPressToGoogleSignUpButton() {
        
        self.authVC.showLoadIndicator()
        
        self.googleAuthCompletion = { googleToken in
            
            if !(googleToken.characters.count > 0) {
                self.authVC.hideLoadIndicator()
                return
            }
            
            self.googleSignUp(googleToken)
        }
        
        self.googleAuth()
    }
    
    
    func didPressToForgotPasswordButton() {
        self.resetPasswordVC = ResetPasswordVC.init(delegate: self)
        self.authVC.navigationController?.pushViewController(self.resetPasswordVC, animated: true)
    }
    
    
    func didPressToDontHaveAccountButton() {
        self.authVC.updateForSignUp()
    }
    
    
    func didPressToHaveAlreadyAccountButton() {
        self.authVC.updateForSignIn()
    }
    
    
    // MARK: - ActivationScenario delegate methods 
    
    
    func stopScenario(scenario: ActivationScenario!) {
        self.authVC.updateForSignUp()
    }
    
    
    func successfullActivation(_ scenario: ActivationScenario!) {
        self.stop()
        scenario.activationVC.dismiss(animated: true, completion: nil)
        self.authVC.dismiss(animated: true, completion: nil)
    }
    
    
    func didPressToBackButton(scenario: ActivationScenario!) {
        scenario.activationVC.navigationController?.setNavigationBarHidden(true, animated: true)
        AuthService.sharedInstance.unauthorized()
        scenario.stop()
    }
    
    
    func didPressToSignOutButton(scenario: ActivationScenario!) {
        
        scenario.activationVC.navigationController?.setNavigationBarHidden(true, animated: true)
        AuthService.sharedInstance.unauthorized()
        scenario.stop()
    }
    
    
    func didPressToTermsButton() {
        let url = URL.init(string: "https://www.kanopy.com/terms")
        self.openURL(url: url)
    }
    
    
    func didPressToPrivacyPolicyButton() {
        let url = URL.init(string: "https://kanopy.com/privacy")
        self.openURL(url: url)
    }
    
    
    func tableViewFrame() -> CGRect {
        return self.authVC.tableView.bounds
    }
    
    
    // MARK: - Tools
    
    
    func openURL(url: URL!) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    // MARK: - ResetPasswordVCDelegate methods 
    
    
    func didPressToResetPasswordButton() {
        
        let email = self.resetPasswordVC.email()
        
        if email.isValidEmail() {
            
            self.resetPasswordVC.showLoadIndicator()
            self.resetPassword(email)
            
        } else {
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: "IS_NOT_VALID_EMAIL".localized,
                                        fromVC: self.authVC)
        }
    }
    
    
    func didPressToBackButton(authVC: AuthVC!) {
        self.authVC.dismiss(animated: true) { 
            self.delegate?.closeScenario(self)
        }
    }
    
    
    func didPressToBackButton(resetPasswordVC: ResetPasswordVC!) {
        self.authVC.navigationController?.popViewController(animated: true)
    }
}


protocol SocialNetworkingInjected {}

extension SocialNetworkingInjected {
    var facebookManager: FBSDKLoginManager { get { return FBInjectedMap.facebookManager }}
}

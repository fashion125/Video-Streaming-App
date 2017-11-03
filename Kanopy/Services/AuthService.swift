//
//  AuthService.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/6/17.
//
//

import UIKit
//import SwiftKeychainWrapper

protocol AuthServiceDelegate {
    
    func notifyAboutChangeCreditLeft()
}

class AuthService: NSObject {

    private(set) var token: String? = ""
    private(set) var sessionToken: String? = ""
    private(set) var user: UserModel!
    private(set) var userID: String! = "0"
    private(set) var currentIdentity: String! = ""
    private(set) var creditsLeftTimer: Timer?
    public var statusModel: StatusActivationModel? = nil
    
    private var observers: NSMutableArray?
    
    /// Instance
    static var sharedInstance = AuthService()
    
    
    // MARK: - Init methods 
    
    
    override init() {
        super.init()
        
        self.observers = NSMutableArray.init()
        self.checkData()
    }
    
    
    // MARK: - Open methods 
    
    
    open func isAuthorized() -> Bool {
        return (self.token != nil && self.token!.characters.count > 0)
    }
    
    
    open func displayName() -> String {
        
        if user != nil && ((user?.displayName) != nil) {
            return (user?.displayName)!
        }
        
        return ""
    }
    
    
    open func getAuthCode(completion: @escaping ((String) -> Void),
                          failure: @escaping ((ErrorModel) -> Void)) {
        RequestService.sharedInstance.getAuthCode(completion: { (authCode: String) in
            completion(authCode)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    open func authCodeVerification(authCode: String?,
                                   activated: @escaping ((String, UserModel) -> Void),
                                   notActivated: @escaping (() -> Void),
                                   failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.authCodeVerification(authCode: authCode,
            completion: { (token: String, user: UserModel?) in
            
                if token.characters.count > 0 {
                    self.sessionToken = token
                    self.updateToken(token: token)
                    self.updateUser(user)
                    activated(token, user!)
                } else {
                    notActivated()
                }
                
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    open func activateAuthcode(authcode: String!,
                     completion: (() -> Void)?,
                     failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.activateAuthcode(authcode: authcode,
                                             completion: { (token: String, user: UserModel) -> Void in
                                                
                                                self.sessionToken = token
                                                self.updateToken(token: token)
                                                completion!()
                                                
        }) { (error: ErrorModel) -> Void in
            failure!(error)
        }
    }
    
    
    open func signIn(authData: AuthDataModel!,
                     completion: ((String) -> Void)?,
                     failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.signIn(authData.email, authData.password,
                                             completion: { (token: String, user: UserModel) -> Void in
                                                
                                                self.updateUser(user)
                                                self.sessionToken = token
                                                self.updateToken(token: token)
                                                completion!(token)
                                                
        }) { (error: ErrorModel) -> Void in
            failure!(error)
        }
    }
    
    
    open func signUp(authData: AuthDataModel!,
                     completion: ((String) -> Void)?,
                     failure: ((ErrorModel) -> Void)?)
    {
        RequestService.sharedInstance.signUp(authData.firstName, authData.lastName,
                                             authData.email, authData.password,
                                             completion: { (tkn: String, user: UserModel) in
                                                
                                                self.updateUser(user)
                                                self.sessionToken = tkn
                                                self.updateToken(token: tkn)
                                                completion!(tkn)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    open func signInWithSocial(provider: String!,
                               token: String!,
                               completion: ((String) -> Void)?,
                               failure: ((ErrorModel) -> Void)?)
    {
        RequestService.sharedInstance.signInWithSocial(provider: provider,
                                                       token: token,
                                                       completion: { (tkn: String, user: UserModel) in
                                                        
                                                        self.updateUser(user)
                                                        self.sessionToken = tkn
                                                        self.updateToken(token: tkn)
                                                        completion!(tkn)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    open func singUpWithSocial(provider: String!,
                               token: String!,
                               completion: ((String) -> Void)?,
                               failure: ((ErrorModel) -> Void)?)
    {
        RequestService.sharedInstance.signUpWithSocial(provider: provider,
                                                       token: token,
                                                       completion: { (tkn: String, user: UserModel) in
                                                        self.updateUser(user)
                                                        self.sessionToken = tkn
                                                        self.updateToken(token: tkn)
                                                        completion!(tkn)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    open func checkStatusVerification(userID: String!,
                                      completion: ((StatusActivationModel) -> Void)?,
                                      failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.checkStatusVerification(userID: userID,
            completion: { (statusModel: StatusActivationModel) -> Void! in
                
                completion!(statusModel)
        }) { (error: ErrorModel) -> Void! in
            failure!(error)
        }
    }
    
    
    open func resendEmail(userID: String!,
                          completion: (() -> Void)?,
                          failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.resendEmail(userID: userID,
                                                  completion: { () -> Void! in
                                                    completion!()
        }) { (error: ErrorModel) -> Void! in
            failure!(error)
        }
    }
    
    
    open func getAutologinUrl(userID: String!, destination: String!, hashtag: String!,
                              completion: ((String) -> Void)?,
                              failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.getAutologinUrl(userID: userID, destination: destination, hashtag: hashtag, completion: { (url: String) in completion!(url) }, failure: { (error: ErrorModel) -> Void in
            failure(error)
        })
    }
    
    
    open func getSessionToken(completion: (() -> Void)?,
                              failure: ((ErrorModel) -> Void)?) {
        
        var authToken: String? = nil
        
        if (self.isAuthorized()) {
            authToken = "Bearer " + self.token!
        }
        
        RequestService.sharedInstance.getToken(authToken: authToken,
                                               completion: { (sessionToken: String, userModel: UserModel) in
            self.sessionToken = sessionToken
                                                self.updateUser(userModel)
            completion!()
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    open func resetPassword(email: String!,
                            completion: (() -> Void)?,
                            failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.resetPassword(email: email,
        completion: {
            completion!()
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    open func getMeUser(completion: ((UserModel) -> Void)?,
                        cacheCompletion: ((UserModel) -> Void)?,
                        failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.getMeUser(completion: { (user: UserModel) in
            self.updateUser(user)
            self.startTimer()
            completion!(user)
        }, cacheCompletion: { (user: UserModel) in
            self.updateUser(user)
            cacheCompletion!(user)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    open func switchMembership(identity: IdentityModel!,
                               completion: ((String) -> Void)?,
                               failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.switchMembership(identity: identity.ID,
                                                       completion: { (token: String) in
                                                        
                                                        self.sessionToken = token
                                                        self.updateToken(token: token)
                                                        self.user?.updateCurrentIdentity(identity)
                                                        self.updateUser(self.user)
                                                        completion!(token)
                                                        self.startTimer()
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    open func unauthorized() {
        self.sessionToken = ""
        self.token = ""
        self.user = nil
        self.userID = "0"
        self.currentIdentity = "0"
        
        
        UserDefaults.standard.removeObject(forKey: Constants.token)
        UserDefaults.standard.removeObject(forKey: Constants.currentUser)
        
        self.updateUser(UserModel.init(anonymousUserWithUserID: "0",
                                       displayName: "Anonymous"))
    }
    
    
    func isHaveCredits() -> Bool {
        
        let ident = self.currentCreditsModel()
        
        if ident != nil && ((ident?.creditAvailable) != -1) {
            return true
        }
        
        return false
    }
    
    
    func currentCreditsModel() -> IdentityModel? {
        
        return self.user?.currentIdentity
    }
    
    
    func currentCreditsValue() -> Int {
        
        let ident = self.currentCreditsModel()
        
        if ident != nil {
            return (ident?.creditAvailable)!
        }
        
        return 0
    }
    
    
    // MARK: - Tools
    
    
    private func checkData() {
        self.checkToken()
        self.checkUserID()
        self.checkCurrentIdentity()
        self.checkCurrentUser()
    }
    
    
    private func checkToken() {
        self.token = UserDefaults.standard.object(forKey: Constants.token) as? String
    }
    
    
    private func checkUserID() {
        self.userID = UserDefaults.standard.object(forKey: Constants.currentUser) as? String
        
        if self.userID == nil {
            self.userID = "0"
        }
    }
    
    
    private func checkCurrentUser() {
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: "current_user")
        self.user = user as? UserModel
    }
    
    
    private func checkCurrentIdentity() {
        self.currentIdentity = UserDefaults.standard.object(forKey: Constants.currentIdentity) as? String
        
        if self.currentIdentity == nil {
            self.currentIdentity = "0"
        }
    }
    
    
    private func updateToken(token: String) {
        
        self.token = token
        UserDefaults.standard.set(self.token, forKey: Constants.token)
        self.sessionToken = token
    }
    
    
    open func updateTokenForTest(token: String?) {
        self.token = token
        self.sessionToken = token
    }
    
    
    open func updateUser(_ user: UserModel!) {
        
        self.user = user
        self.userID = self.user?.userID
        self.currentIdentity = String(describing: self.user?.currentIdentity?.ID)
        
        UserDefaults.standard.set(self.userID, forKey: Constants.currentUser)
        UserDefaults.standard.set(self.currentIdentity, forKey: Constants.currentIdentity)
        
        if self.user?.userID == "0" {
            self.token = ""
            UserDefaults.standard.removeObject(forKey: Constants.token)
        }
        
        NSKeyedArchiver.archiveRootObject(self.user!, toFile: "current_user")
    }
    
    
    private func saveCredentionals(email: String!, password: String!) {
//        KeychainWrapper.standard.set(email, forKey: "email")
//        KeychainWrapper.standard.set(password, forKey: "password")
    }
    
    
    func startTimer() {
        
        if (self.user.currentIdentity?.creditAvailable)! > 0 {
            self.stopTimer()
            self.creditsLeftTimer = self.createTimer()
        }
    }
    
    
    open func createTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
    }
    
    
    func stopTimer() {
        self.creditsLeftTimer?.invalidate()
        self.creditsLeftTimer = nil
    }
    
    
    func update() {
        
        self.getMeUser(completion: { (user: UserModel) in
            
            self.notifyAllObserversAboutChangePublicCreditsLeft()
            
        }, cacheCompletion: { (user: UserModel) in
            
        }) { (error: ErrorModel) in
            
        }
    }
    
    
    // MARK: - Observers methods
    
    
    open func addObserver(observer: AuthServiceDelegate!) {
        if !(self.observers?.contains(observer))! {
            self.observers?.add(observer)
        }
    }
    
    
    open func removeObserver(observer: AuthServiceDelegate!) {
        if (self.observers?.contains(observer))! {
            self.observers?.remove(observer)
        }
    }
    
    
    open func notifyAllObserversAboutChangePublicCreditsLeft() {
        let observersArray = self.observers
        
        for delegate in observersArray! {
            let dg = delegate as! AuthServiceDelegate
            dg.notifyAboutChangeCreditLeft()
        }
    }
}


// MARK: - For tests


protocol AuthServiceInjected {}

extension AuthServiceInjected {
    var authService: AuthService { get { return InjectedMap.authService }}
}

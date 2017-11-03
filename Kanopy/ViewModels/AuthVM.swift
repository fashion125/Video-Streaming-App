//
//  AuthVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class AuthVM: GenericVM {

    open var emailCM: TextFieldCellModel!
    open var passwordCM: TextFieldCellModel!
    open var fullNameCM: TextFieldCellModel?
    
    open var authButtonCM: ButtonCellModel!
    open var socialCM: SocialCellModel!
    
    open var loadCM: GenericCellModel?
    
    
    // MARK: - Init methods 
    
    
    override init() {
        super.init()
    }
    
    
    func generateSections() {
    }
    
    
    open func firstName() -> String? {
        return fullNameCM?.value
    }
    
    
    open func lastName() -> String? {
        return fullNameCM?.additionalValue
    }
    
    
    open func email() -> String {
        return emailCM.value
    }
    
    
    open func password() -> String {
        return passwordCM.value
    }
    
    
    open func showLoadCellModel() {
        
        let indexPath = self.indexPath(cellModel: self.authButtonCM)
        self.loadCM = GenericCellModel.init(TableCellIDs.loadTableCell, height: 48.0)
        
        self.removeCellModel(indexPath: indexPath)
        self.insertCellModel(indexPath: indexPath, cellModel: self.loadCM)
    }
    
    
    open func showAuthButton() {
        
        let indexPath = self.indexPath(cellModel: self.loadCM)
        self.removeCellModel(indexPath: indexPath)
        self.insertCellModel(indexPath: indexPath, cellModel: self.authButtonCM)
    }
    
    
    // MARK: -
    
    
    // MARK: -
    
    
    func checkFirstName() -> String {
        
        if self.fullNameCM != nil {
            return (self.fullNameCM?.value)!
        }
        
        return ""
    }
    
    
    func checkLastName() -> String {
        
        if self.fullNameCM != nil {
            return (self.fullNameCM?.additionalValue)!
        }
        
        return ""
    }
    
    
    func checkEmail() -> String {
        
        if self.emailCM != nil {
            return (self.emailCM.value)!
        }
        
        return ""
    }
    
    
    func checkPassword() -> String {
        
        if self.passwordCM != nil {
            return (self.passwordCM.value)!
        }
        
        return ""
    }
}

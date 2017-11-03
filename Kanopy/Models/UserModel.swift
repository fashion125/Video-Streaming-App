//
//  UserModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/10/17.
//
//

import UIKit

class UserModel: NSObject, NSCoding {

    static let userIDKey: String = "user_id"
    static let userNameKey: String = "user_name"
    static let displayNameKey: String = "display_name"
    static let mailKey: String = "mail"
    static let statusKey: String = "status"
    static let statusValueKey: String = "status_value"
    static let currentIdentityKey: String = "current_identity"
    static let avatarKey: String = "avatar_key"
    
    
    // MARK: -
    
    
    private(set) var userID: String? = ""
    private(set) var username: String? = ""
    private(set) var displayName: String? = ""
    private(set) var mail: String? = ""
    private(set) var status: Bool? = false
    private(set) var statusKey: String? = ""
    private(set) var currentIdentity: IdentityModel? = nil
    private(set) var avatar: String?
    private(set) var myWathclistID: String? = ""
    
    var identities: Array<IdentityModel> = [IdentityModel]()
    
    
    // MARK: - Init method 
    
    
    init(userID: String?, username: String?, displayName: String?, mail: String?, status: Bool?, statusKey: String?, currentIdentity: IdentityModel?, avatar: String!, myWathclistID: String?) {
        
        super.init()
        
        self.userID = userID != nil ? userID : "0"
        self.username = username != nil ? username : "Anonymous"
        self.displayName = displayName != nil ? displayName : "Anonymous"
        self.mail = mail != nil ? mail : ""
        self.status = status != nil ? status : true
        self.statusKey = statusKey != nil ? statusKey : "active"
        self.currentIdentity = currentIdentity
        self.avatar = avatar
        self.myWathclistID = myWathclistID
    }
    
    
    init(anonymousUserWithUserID userID: String, displayName: String) {
        
        super.init()
        
        self.userID = userID
        self.username = displayName
        self.displayName = displayName
        self.status = true
        self.statusKey = "active"
    }
    
    
    init(forTestWithUserID userID: String!) {
        super.init()
        
        self.userID = userID
        self.displayName = "Display Name"
        self.status = true
        self.statusKey = "active"
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let userID = aDecoder.decodeObject(forKey: UserModel.userIDKey) as! String
        let userName = aDecoder.decodeObject(forKey: UserModel.userNameKey) as! String
        let displayName = aDecoder.decodeObject(forKey: UserModel.displayNameKey) as! String
        let mail = aDecoder.decodeObject(forKey: UserModel.mailKey) as! String
        let status = aDecoder.decodeBool(forKey: UserModel.statusKey) 
        let statusKey = aDecoder.decodeObject(forKey: UserModel.statusValueKey) as! String
        
        self.init(userID: userID,
                  username: userName,
                  displayName: displayName,
                  mail: mail,
                  status: status,
                  statusKey: statusKey,
                  currentIdentity: nil,
                  avatar: "",
                  myWathclistID: "")
    }
    
    
    func updateCurrentIdentity(_ identity: IdentityModel!) {
        self.currentIdentity = identity
    }
    
    
    func defaultMembership() -> IdentityModel? {
        
        for idnt in self.identities {
            if idnt.isDefault {
                return idnt
            }
        }
        
        return nil
    }
    
    
    // MARK: - Tools 
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: UserModel.userIDKey)
        aCoder.encode(self.username, forKey: UserModel.userNameKey)
        aCoder.encode(self.displayName, forKey: UserModel.displayNameKey)
        aCoder.encode(self.mail, forKey: UserModel.mailKey)
        aCoder.encode(self.status, forKey: UserModel.statusKey)
        aCoder.encode(self.statusKey, forKey: UserModel.statusValueKey)
    }
}

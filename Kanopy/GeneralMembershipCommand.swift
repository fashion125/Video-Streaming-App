//
//  GeneralMembershipCommand.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 30/05/2017.
//
//

import UIKit

class GeneralMembershipCommand: GeneralCommand {
    
    private(set) var delegate: MembershipsVCDelegate!
    private(set) var hashtag: String! = ""
    private(set) var destination: String! = "user/" + (AuthService.sharedInstance.user?.userID)! + "/identities"
    
    init(delegate: MembershipsVCDelegate!, hashtag: String!) {
        super.init()
        
        self.delegate = delegate
        self.hashtag = hashtag
    }
    
    init(delegate: MembershipsVCDelegate!, destination: String!) {
        super.init()
        
        self.delegate = delegate
        self.destination = destination
    }
    
    init(delegate: MembershipsVCDelegate!, destination: String!, hashtag: String!) {
        super.init()
        
        self.delegate = delegate
        self.destination = destination
        self.hashtag = hashtag
    }
}

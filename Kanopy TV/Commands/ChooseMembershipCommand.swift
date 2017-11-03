//
//  ChooseMembershipCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

class ChooseMembershipCommand: MembershipListCommand {

    func execute(identity: IdentityModel!) {
        self.delegate.didChooseIdentity(identity: identity)
    }
}

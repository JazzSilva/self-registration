//
//  model.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation

class user {
    var usersPersonalInformation: personalInformation?
    var usersSecurityInformation: securityInformation?
    var usersAddressInformation: addressInformation?
    var usersLibraryCardInformation: libraryCard?
    
    deinit {
        print("\(self) is being deinitialized")
    }
}





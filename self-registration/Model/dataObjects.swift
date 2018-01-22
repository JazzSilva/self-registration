//
//  objects.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation

struct personalInformation {
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var birthday: NSDate?
    var cellPhone: String?
    var email: String?
}

struct securityInformation {
    var mothersMaidenName: String?
    var pin: String?
    var signature: Data?
    var holds: String?
}

struct addressInformation {
    var address1: String?
    var city: String?
    var state: String?
    var zip: String?
}

struct libraryCard {
    var libraryCardNumber: String?
    var licenseNumber: String?
}

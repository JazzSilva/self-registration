//
//  model.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import RealmSwift

class user: Object {
    
    @objc dynamic var dateCreated = NSDate()
    
    @objc dynamic var firstName: String?
    @objc dynamic var middleName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var birthday: NSDate?
    
    @objc dynamic var address1: String?
    @objc dynamic var city: String?
    @objc dynamic var state: String?
    @objc dynamic var zip: String?
    
    @objc dynamic var phone: String?
    @objc dynamic var email: String?
    
    @objc dynamic var mothersMaidenName: String?
    @objc dynamic var pin: String?
    @objc dynamic var holds: String?
    @objc dynamic var signature: String? /// FIX: Change this data type to data
    
    @objc dynamic var libraryCardNumber: String?
    @objc dynamic var licenseNumber: String?
    
    override static func primaryKey() -> String? {
        return ""
    }
    
}






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
    //@objc dynamic var id = ""
    
    @objc dynamic var firstName: String? = nil
    @objc dynamic var middleName: String? = nil
    @objc dynamic var lastName: String? = nil
    @objc dynamic var birthday: NSDate? = nil
    
    @objc dynamic var address1: String? = nil
    @objc dynamic var city: String? = nil
    @objc dynamic var state: String? = nil
    @objc dynamic var zip: String? = nil
    
    @objc dynamic var phone: String? = nil
    @objc dynamic var email: String? = nil
    
    @objc dynamic var mothersMaidenName: String? = nil
    @objc dynamic var pin: String? = nil
    @objc dynamic var holds: String? = nil
    @objc dynamic var signature: String? = nil /// FIX: Change this data type to data
    
    @objc dynamic var libraryCardNumber: String? = nil
    @objc dynamic var licenseNumber: String? = nil
    
    /*override static func primaryKey() -> String? {
        return "id"
    }*/
    
    //May not be necessary. Need to add other fields
    convenience init(firstName: String?, middleName: String?, lastName: String?, address1: String?, city: String?, state: String?, zip: String?, phone: String?, email: String?, mothersMaidenName: String?, pin: String?, holds: String?) {
        self.init()
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.address1 = address1
        self.city = city
        self.state = state
        self.zip = zip
        self.phone = phone
        self.email = email
        self.mothersMaidenName = mothersMaidenName
        self.pin = pin
        self.holds = holds
    }
    
}






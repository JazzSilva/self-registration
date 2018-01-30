//
//  objects.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    static let singleton = Database()
   
    private init() {}
    
    func createUser(userValue: String) -> Void {
        //need to set up different database configs, so people can only update their own information
        //Could use "int" method to implement auto increment / update
        let realm = try! Realm()
        let userEntity = user()
        userEntity.firstName = userValue
        try! realm.write {
            realm.add(userEntity)
        }
    }
    
    func fetch() -> Results<user> {
        let realm = try! Realm()
        return realm.objects(user.self)
    }

}

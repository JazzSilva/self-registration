//
//  viewModel.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift 

class userViewModel {
    
    var database: Database?
    
    init() {
        database = Database.singleton
    }
    
    var firstName = Variable<String?>("")
    var middleName = Variable<String?>("")
    var lastName = Variable<String?>("")
    
    var address1 = Variable<String>("")
    var city = Variable<String>("")
    var state = Variable<String>("")
    var zip = Variable<String>("")
    
    var mothersMaidenName = Variable<String>("")
    var pin = Variable<String>("")
    var holds = Variable<String>("")
    
    var phone = Variable<String>("")
    var email = Variable<String>("")
    
    var isNameValid: Observable<Bool> {
        return Observable.combineLatest(firstName.asObservable(), middleName.asObservable(), lastName.asObservable()) {
            first, middle, last in first!.isEmpty == false && middle!.isEmpty == false && last!.isEmpty == false
        }
    }
    
    //Just for test purposes: dont want to do more than once. try to load realm database
    var realm = try! Realm()
    
    func addUser() {
        //add new user to the realm database
        //let newUser = user()
        //newUser.firstName = self.firstName
        //newUser.middleName = self.middleName
        //newUser.lastName = self.lastName
    }
    
    func displayUsers() -> Results<user> {
        //display users in currect database
        return realm.objects(user.self)
    }
    
}


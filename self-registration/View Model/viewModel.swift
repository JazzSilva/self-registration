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
    
    let firstName = Variable<String>("")
    let middleName = Variable<String>("")
    let lastName = Variable<String>("")
    
    let address1 = Variable<String>("")
    let city = Variable<String>("")
    let state = Variable<String>("")
    let zip = Variable<String>("")
    
    let mothersMaidenName = Variable<String>("")
    let pin = Variable<String>("")
    let holds = Variable<String>("")
    
    let phone = Variable<String>("")
    let email = Variable<String>("")
    
    var isNameValid: Observable<Bool> {
        return Observable.combineLatest(firstName.asObservable(), middleName.asObservable(), lastName.asObservable()) {
            first, middle, last in first.count > 0 && middle.count > 0 && last.count > 0
        }
    }
    
    var isAddressValid: Observable<Bool> {
        return Observable.combineLatest(address1.asObservable(), city.asObservable(), state.asObservable(), zip.asObservable()) {
            address1, city, state, zip in address1.count > 0 && city.count > 0 && state.count == 2 && zip.count == 5
        }
    }
    
    var isSecurityValid: Observable<Bool> {
        return Observable.combineLatest(mothersMaidenName.asObservable(), pin.asObservable(), holds.asObservable()) {
            mothersMaidenName, pin, holds in mothersMaidenName.count > 0 && pin.count == 4 && holds.count >= 0
        }
    }
    
    var isContactValid: Observable<Bool> {
        return Observable.combineLatest(phone.asObservable(), email.asObservable()) {
            phone, email in phone.count > 0 && email.count > 0
        }
    }
    
    var isFormComplete: Observable<Bool> {
        return Observable.combineLatest(isNameValid, isAddressValid, isSecurityValid, isContactValid) {
            name, address, security, contact in name && address && security && contact
        }
    }
    
    
}


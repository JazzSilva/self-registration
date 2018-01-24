//
//  viewModel.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import RxSwift

class userViewModel {
    
    var firstName = Variable<String>("")
    var middleName = Variable<String>("")
    var lastName = Variable<String>("")
    
    var address1 = Variable<String>("")
    var city = Variable<String>("")
    var state = Variable<String>("")
    var zip = Variable<String>("")
    
    var code = Variable<String>("")
    var pin = Variable<String>("")
    var holds = Variable<String>("")
    
    var isNameValid: Observable<Bool> {
        return Observable.combineLatest(firstName.asObservable(), middleName.asObservable(), lastName.asObservable()) {
            first, middle, last in first.isEmpty == false && middle.isEmpty == false && last.isEmpty == false
        }
    }
    
}


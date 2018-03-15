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
    
    var realm: Realm?
    let disposeBag = DisposeBag()
    
    //This is a singleton
    init() {
        realm = Database.shared.realm
        libraryCardNumber.value = getLibraryCardNumber()
        dateCreated.value = getDateCreatedToString(date: NSDate())
        branchCode.value = Database.shared.currentUser
    }
    
    let firstName = Variable<String>("")
    let middleName = Variable<String>("")
    let lastName = Variable<String>("")
    let birthday = Variable<String>("")
    
    let address1 = Variable<String>("")
    let city = Variable<String>("")
    let state = Variable<String>("")
    let zip = Variable<String>("")
    
    let mothersMaidenName = Variable<String>("")
    let pin = Variable<String>("")
    let holds = Variable<String>("")
    
    let phone = Variable<String>("")
    let email = Variable<String>("")
    
    let isChildUser = Variable<Bool>(false)
    let verified = Variable<Bool>(false)
    let licenseNumber = Variable<String>("")
    let libraryCardNumber = Variable<String>("")
    
    let dateCreated = Variable<String>("")
    let userProfile = Variable<String>("HC-DigitaJ")
    let branchCode = Variable<String>("")
    let contactPreference = Variable<String>("")
    
    var signature = Variable<String>("")
    
    var firstNameValid: Observable<Bool> { return firstName.asObservable().map() { item in isLettersAndCharacters(input: item) && item.count >= 1} }
    var middleNameValid: Observable<Bool> { return middleName.asObservable().map() { item in isLettersAndCharacters(input: item) && item.count >= 0} }
    var lastNameValid: Observable<Bool> { return lastName.asObservable().map() { item in isLettersAndCharacters(input: item) && item.count >= 1} }
    var address1Valid: Observable<Bool> { return address1.asObservable().map() { item in item.count >= 1} }
    var cityValid: Observable<Bool> { return city.asObservable().map() { item in isLettersAndCharacters(input: item) && item.count >= 1} }
    var stateValid: Observable<Bool> { return state.asObservable().map() { item in isLettersOnly(input: item) && item.count == 2} }
    var zipValid: Observable<Bool> { return zip.asObservable().map() { item in isNumbersOnly(input: item) && item.count == 5} }
    var mothersMaidenNameValid: Observable<Bool> { return mothersMaidenName.asObservable().map() { item in isLettersAndCharacters(input: item) && item.count >= 1} }
    var pinValid: Observable<Bool> { return pin.asObservable().map() { item in isNumbersOnly(input: item) && item.count == 4} }
    var holdsValid: Observable<Bool> { return holds.asObservable().map() { item in isLettersAndCharacters(input: item) && item.count >= 0} }
    var phoneValid: Observable<Bool> { return phone.asObservable().map() { item in isValidPhone(input: item)} }
    var emailValid: Observable<Bool> { return email.asObservable().map() { item in isValidEmail(input: item)} }
    var verifiedValue: Observable<Bool> { return verified.asObservable().map() { item in item } }

    var isNameViewValid: Observable<Bool> { return Observable.combineLatest(firstNameValid, middleNameValid, lastNameValid) { first, middle, last in first && middle && last } }
    var isAddressViewValid: Observable<Bool> { return Observable.combineLatest(address1Valid, cityValid, stateValid, zipValid) { address, city, state, zip in address && city && state && zip} }
    var isSecurityViewValid: Observable<Bool> { return Observable.combineLatest(mothersMaidenNameValid, pinValid) { mothersMaidenName, pin in mothersMaidenName && pin } }
    var isContactViewValid: Observable<Bool> { return Observable.combineLatest(phoneValid, emailValid) { phone, email in phone && email } }
    
    var isFormComplete: Observable<Bool> { return Observable.combineLatest(isNameViewValid, isAddressViewValid, isSecurityViewValid, isContactViewValid) { name, address, security, contact in name && address && security && contact } }
    
    @objc func createUser(sender: AnyObject) {
        //This references the convenience user init in the Database class
        let newUser = user(firstName: firstName.value.uppercased(), middleName: middleName.value.uppercased(), lastName: lastName.value.uppercased(), address1: address1.value.uppercased(), city: city.value.uppercased(), state: state.value.uppercased(), zip: zip.value, phone: phone.value, email: email.value, mothersMaidenName: mothersMaidenName.value.uppercased(), pin: pin.value, holds: holds.value.uppercased(), signature: signature.value, birthday: birthday.value, verified: verified.value, userProfile: userProfile.value, licenseNumber: licenseNumber.value, libraryCardNumber: libraryCardNumber.value, branchCode: branchCode.value, contactPreference: contactPreference.value, dateCreated: dateCreated.value)
        //Actually save the user to the shared realm
        Database.shared.create(newUser)
        sendToSirsi(user: newUser)
        if isChildUser.value { sendParentSMS(user: newUser) } else { text(user: newUser) }
    }
    
}


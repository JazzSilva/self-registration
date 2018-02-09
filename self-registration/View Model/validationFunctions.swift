//
//  validationFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import RxSwift

public func isNumbersOnly(input: String) -> Bool {
    let digits = CharacterSet.decimalDigits
    for items in input.unicodeScalars {
        if digits.contains(items) { return true } }
    return false }

public func isLettersOnly(input: String) -> Bool {
    let digits = CharacterSet.decimalDigits
    for items in input.unicodeScalars {
        if digits.contains(items) { return false } }
    return true }

public func isLettersAndCharacters(input: String) -> Bool {
    let set: CharacterSet = CharacterSet(charactersIn: input.replacingOccurrences(of: "\\s|-|'|,", with: "", options: .regularExpression))
    let allowedCharacters: CharacterSet = CharacterSet.letters
    return allowedCharacters.isSuperset(of: set)
}

public func isValidEmail(input: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: input)
}

public func isValidPhone(input: String) -> Bool {
    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: input)
    return result
}

// FIXME: implement incorrentLength error
// FIXME: implement invalidFormat error

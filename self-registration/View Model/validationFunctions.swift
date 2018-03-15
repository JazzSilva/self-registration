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
        if digits.contains(items) { return true }
        else {
            return false
        }
    }
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
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: input)
}

public func isValidPhone(input: String) -> Bool {
    if isNumbersOnly(input: input) && input.count == 10 {
        return true
    }
    else {
        return false
    }
}

func getBirthdayToString(date: NSDate) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let string1 = dateFormatter.string(from: date as Date)
    let date1 = dateFormatter.date(from: string1)
    return dateFormatter.string(from: date1!)
}

func getDateCreatedToString(date: NSDate) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let string1 = dateFormatter.string(from: date as Date)
    let date1 = dateFormatter.date(from: string1)
    return dateFormatter.string(from: date1!)
}

func random9DigitString() -> String {
    let min: UInt32 = 100_000_000
    let max: UInt32 = 999_999_999
    let i = min + arc4random_uniform(max - min + 1)
    return String(i)
}

public func calculateTimeDistance(date: NSDate) -> Bool {
    var child = false
    let time = (date.timeIntervalSince(Date())) / 31536000
    if time >= -18 {
        child = true
    }
    return child
}

public func isChild(_ dateAsString: String) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let DOB = formatter.date(from: dateAsString)
    return calculateTimeDistance(date: DOB! as NSDate)
}

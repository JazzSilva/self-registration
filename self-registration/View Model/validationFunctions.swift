//
//  validationFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation

enum inputError: Error {
    case containsNumbers
    case containsCharacters
    case invalidFormat
    case incorrectLength
    case isEmpty
}

func doesContainNumbers(input: String) throws {
    let digits = CharacterSet.decimalDigits
    for items in input.unicodeScalars {
        if digits.contains(items) {
            throw inputError.containsNumbers
        }
    }
}

func doesContainLetters(input: String) throws {
    let digits = CharacterSet.decimalDigits
    for items in input.unicodeScalars {
        if digits.contains(items) == false {
            throw inputError.containsCharacters
        }
    }
}

// FIXME: implement isEmpty error
func isEmpty(input: String?) throws {
    if input!.isEmpty {
      throw inputError.isEmpty
    }
}

// FIXME: implement incorrentLength error
// FIXME: implement invalidFormat error

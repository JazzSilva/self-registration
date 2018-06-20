//
//  constantManager.swift
//  self-registration
//
//  Created by Jasmin Silva on 6/2/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation

class constants {
    
    static let sharedInstance = constants()
    
    enum console {
        static let databaseDidUpdate = "Database did Update"
        static let sessionTokenSuccess = "Got Session Token"
        static let sessionTokenFailure = "Could Not Get Session Token"
        static let accountDoesExist = "Account Does Exist"
        static let accountDoesNotExist = "Account Does Not Exist"
    }
    
    enum buttons {
        static let resendCode = "Resend Electronic Code"
        static let createAccount = "Create Account"
        static let startOver = "Start Over"
    }
    
    enum labels {
        static let accountNotInSirsi = "Account Not In Sirsi"
        static let incorrectLogIn = "Incorrect password or username"
    }
    
    enum colors {
        static let greenEnabled = UIColor(hex: "6AB97C")
        static let blueText = UIColor(hex: "111777")
        static let redInvalid = UIColor(hex: "C4174A")
        static let greenValid = UIColor(hex: "020002")
        static let orange = UIColor(hex: "C8A8F9")
    }
    
    enum cardPrefix {
        static let texasPrefix = "636015"
        static let adultInState = "HCPL"
        static let adultOutState = "HCPL"
    }
    
    enum accountType {
        static let adultInState = "A"
        static let adultOutState = "VSA"
        static let childInState = "C"
        static let childOutState = "VSC"
        static let digital = "SELFREG" //TODO Change to "SELFREG" not "HC-DigitaJ"
    }
    
}

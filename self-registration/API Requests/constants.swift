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
        static let headerTextColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "headerTextColor").stringValue!
        static let fieldTextPlaceholderColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "fieldTextPlaceholderColor").stringValue!
        static let fieldTextInputColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "fieldTextInputColor").stringValue!
        static let submitButtonColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "submitButtonColor").stringValue!
        static let submitTextColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "submitTextColor").stringValue!
        static let tabInactiveBackgroundColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "tabInactiveBackgroundColor").stringValue!
        static let tabInactiveText = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "tabInactiveText").stringValue!
        static let tabActiveBackgroundColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "tabActiveBackgroundColor").stringValue!
        static let tabActiveText = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "tabActiveText").stringValue!
        static let restartButtonColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "restartButtonColor").stringValue!
        static let restartTextColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "restartTextColor").stringValue!
        static let invalidEntryColor = Firebase.RemoteConfig.remoteConfig().configValue(forKey: "invalidEntryColor").stringValue!
        
        //Old Colors
        static let greenEnabled = UIColor(hex: "286A61")
        static let blueText = UIColor(hex: "153C67")
        static let redInvalid = UIColor(hex: "C8041B")
        static let greenValid = UIColor(hex: "286A61")
        static let pink = UIColor(hex: "D40177")
        static let whiteText = UIColor(hex: "F4F4F4")
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
        static let digital = "SELFREG" 
    }
    
}

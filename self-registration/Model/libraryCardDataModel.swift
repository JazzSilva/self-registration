//
//  libraryCardDataModel.swift
//  self-registration
//
//  Created by Jasmin Silva on 6/4/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct libraryCard {
    
    init() {
        print("I am created")
    }
    var generatedNumber = constants.cardPrefix.adultInState + random9DigitString()
    var correctNumber = ""
    var fourteenDigitLicense: String?
    var eightDigitLicense: String {
        guard let licenseNumberWithoutPrefix = fourteenDigitLicense?.dropFirst(6) else {
            return ""
        }
        return String(licenseNumberWithoutPrefix)
    }
    var sixDigitStatePrefix: String {
        guard let prefixValue = fourteenDigitLicense?.prefix(6) else {
            return ""
        }
        return String(prefixValue)
    }
    
    var driversLicenseWithCorrectedPrefix: String {
        if self.sixDigitStatePrefix == "" {
            return ""
        }
        else {
            return constants.cardPrefix.adultInState + self.eightDigitLicense
        }
    }
    
}





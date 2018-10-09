//
//  lilitabSwipe.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import LilitabSDK


extension homeXib {
    
    public func swipeFunc(_ swipeData: Any?) -> Void {
        //Put the data from the ID into a dictionary
        if let swipeData = swipeData as! [String:Any]? {
            let data = swipeData["rawData"] as! String
    
            var i = 0
            //Parse raw data into a dictionary where an index (1-4) corresponds to each field separator (^)
            for items in data.components(separatedBy: "^") {
                i = i + 1
                self.userDict[i] = items
            }
            
            do {
                //Use regular expressions to parse each of the 4 track lines to get each field
                guard let city = self.userDict[1],
                    let name = self.userDict[2],
                    let address = self.userDict[3],
                    let zip = self.userDict[4]
                else {
                    self.animateUnableToReadSwipeView()
                    return
                    }
                self.cityState(input: city)
                self.name(input: name)
                self.addressInput(input: address)
                self.zipDobNumber(input: zip)
            }

            newLibraryCard.fourteenDigitLicense = self.userInformation["DL Number"]?.first!
            
            //Need to update workflow in twilio for checking if account exists
            self.animateSuccessfulSwipeView()
        }
        else {
            //If the swipe cannot read the card data, trigger this function
            self.animateUnableToReadSwipeView()
        }
    }

    public func cityState(input :String) {
        userInformation["State"] = input.capturedGroups(withRegex: "[%](..)[.]*")
        userInformation["City"] = input.capturedGroups(withRegex: "[%]..(.*)")
    }
    
    public func name(input :String) {
        userInformation["Last"] = input.capturedGroups(withRegex: "([^$].*)[$]")
        userInformation["First"] = input.capturedGroups(withRegex: "[^$].*[$](.*)$*")
    }
    
    public func addressInput(input: String) {
        userInformation["Address 1"] = [input]
    }
    
    public func zipDobNumber(input: String) {
        userInformation["Zip"] = input.capturedGroups(withRegex: "[?][#]..([0-9][0-9][0-9][0-9][0-9])")
        userInformation["DL Number"] = input.capturedGroups(withRegex: "[?][;]([0-9]*)[=]")
        userInformation["DOB"] = input.capturedGroups(withRegex: "[=]....([0-9]*)[?]")
    }
    
}




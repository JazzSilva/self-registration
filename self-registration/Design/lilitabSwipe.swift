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
    
    public func swipeFunc(_ swipeData: [AnyHashable: Any]?) -> Void {
        //Put the data from the ID into a dictionary
        if let swipeData = swipeData as NSDictionary? as! [String:Any]? {
            let data = swipeData["rawData"] as! String
            
            var i = 0
            //Parse raw data into a dictionary where an index (1-4) corresponds to each field separator (^)
            for items in data.components(separatedBy: "^") {
                i = i + 1
                self.userDict[i] = items
            }
            
            do {
                //Use regular expressions to parse each of the 4 track lines to get each field
                self.cityState(input: self.userDict[1]!)
                self.name(input: self.userDict[2]!)
                self.addressInput(input: self.userDict[3]!)
                self.zipDobNumber(input: self.userDict[4]!)
            }
            
            getSessionToken { (success) -> Void in
                if success {
                    print("got session token", NSDate())
                    // do second task if success
                    doesAccountExist((self.userInformation["DL Number"]?.first!)!) { (success) -> Void in
                        if success {
                            print("account does exist")
                            print("card number was already in use")
                            self.hello()
                        }
                        else {
                            print("account does not exist")
                            print("account does not exist")
                            print("card number was not in use")
                            self.accountDoesNotExistAction()
                        }
                    }
                }
                else {
                    print("did not get session token")
                    sessionTokenError()
                }
            }
        
        }
        
   }
    public func hello() {
        self.animateError()
    }
    
    public func accountDoesNotExistAction() {
        self.firstSwipe.text = self.userInformation["First"]?.first
        self.lastSwipe.text = self.userInformation["Last"]?.first
        self.addressSwipe.text = self.userInformation["Address 1"]?.first
        self.citySwipe.text = self.userInformation["City"]?.first
        self.dobSwipe.text = self.userInformation["DOB"]?.first
        self.stateSwipe.text = self.userInformation["State"]?.first
        self.zipSwipe.text = self.userInformation["Zip"]?.first
        self.licenseSwipe.text = self.userInformation["DL Number"]?.first
        self.animateSwipe()
        accountDoesNotExist()
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
        userInformation["Zip"] = input.capturedGroups(withRegex: "[?]...([0-9]*) ")
        userInformation["DL Number"] = input.capturedGroups(withRegex: "[?][;]([0-9]*)[=]")
        userInformation["DOB"] = input.capturedGroups(withRegex: "[=]....([0-9]*)[?]")
    }
    
}




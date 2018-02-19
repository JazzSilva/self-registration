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
    
    public func initalizeSwipe() {
                
        //Enable Basic Scanner Settings
        LilitabSDK.singleton().scanForConnectedAccessories()
        let swipe = LilitabSDK.singleton()
        swipe?.enableSwipe = true
        swipe?.swipeTimeout = 0
        swipe?.allowMultipleSwipes = false // this was changed from true - test
        swipe?.ledState = LilitabSDK_LED_Mode.LED_On
        
        //When a card is swiped, this block is executed
        swipe?.swipeBlock = {(_ swipeData: [AnyHashable: Any]?) -> Void in
            
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
                
                //Set information in pop-up view
                self.firstSwipe.text = self.userInformation["First"]?.first
                self.lastSwipe.text = self.userInformation["Last"]?.first
                self.addressSwipe.text = self.userInformation["Address 1"]?.first
                self.citySwipe.text = self.userInformation["City"]?.first
                self.dobSwipe.text = self.userInformation["DOB"]?.first
                self.stateSwipe.text = self.userInformation["State"]?.first
                self.zipSwipe.text = self.userInformation["Zip"]?.first
                self.licenseSwipe.text = self.userInformation["DL Number"]?.first
            }
            self.animateSwipe()
        }
    }
    
        private func cityState(input :String) {
            userInformation["State"] = input.capturedGroups(withRegex: "[%](..)[.]*")
            userInformation["City"] = input.capturedGroups(withRegex: "[%]..(.*)")
        }
        
        private func name(input :String) {
            userInformation["Last"] = input.capturedGroups(withRegex: "([^$].*)[$]")
            userInformation["First"] = input.capturedGroups(withRegex: "[^$].*[$](.*)$*")
        }
        
        private func addressInput(input: String) {
            userInformation["Address 1"] = [input]
        }
        
        private func zipDobNumber(input: String) {
            userInformation["Zip"] = input.capturedGroups(withRegex: "[?]...([0-9]*) ")
            userInformation["DL Number"] = input.capturedGroups(withRegex: "[?][;]([0-9]*)[=]")
            userInformation["DOB"] = input.capturedGroups(withRegex: "[=]....([0-9]*)[?]")
        }
    
}




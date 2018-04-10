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
            
            //Standard popup view should appear if this is a new user
            if doesAccountExist(id: (userInformation["DL Number"]?.first)!) == false {
                self.firstSwipe.text = self.userInformation["First"]?.first
                self.lastSwipe.text = self.userInformation["Last"]?.first
                //self.userInformation["Address 1"]?.first
                self.addressSwipe.text = "Did not"
                self.citySwipe.text = self.userInformation["City"]?.first
                self.dobSwipe.text = self.userInformation["DOB"]?.first
                self.stateSwipe.text = self.userInformation["State"]?.first
                self.zipSwipe.text = self.userInformation["Zip"]?.first
                self.licenseSwipe.text = self.userInformation["DL Number"]?.first
                
                animateSwipe()
            }
            //This user already exists in the system
            else {
                self.addSubview(accountExists)
                accountExists.center = CGPoint(x: self.center.x, y: self.center.y + 50)
                accountExists.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                animationView.transform = CGAffineTransform.identity
                swipedView.alpha = 0
                UIView.animate(withDuration: 0.4) {
                    self.accountExists.alpha = 1
                    self.accountExists.transform = CGAffineTransform.identity
                    self.animationView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                }
                accountExistsButton.enableSettings()
            }
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
        userInformation["Zip"] = input.capturedGroups(withRegex: "[?]...([0-9]*) ")
        userInformation["DL Number"] = input.capturedGroups(withRegex: "[?][;]([0-9]*)[=]")
        userInformation["DOB"] = input.capturedGroups(withRegex: "[=]....([0-9]*)[?]")
    }
    
}




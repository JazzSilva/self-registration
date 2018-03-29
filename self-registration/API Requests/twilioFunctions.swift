//
//  twilioFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation


func sendBarcodeToSMS(user: user, mediaURL: String) {
    //Initialize Twilio Settings: Need to change to remote config
    guard let toNumber = user.phone else { return }
    guard let name = user.firstName else { return }
    let message = "Hello \(name)! Your library card number is \(user.libraryCardNumber ?? ""). Use this barcode at the circulation desk to checkout materials."
    
    let request = NSMutableURLRequest(url: URL(string:"https://\(RCValues.sharedInstance.string(forKey: .twilioSID)):\(RCValues.sharedInstance.string(forKey: .twilioSecret))@api.twilio.com/2010-04-01/Accounts/\(RCValues.sharedInstance.string(forKey: .twilioSID))/Messages")!)
    request.httpMethod = "POST"
    print("media URL: is", mediaURL)
    let allowedCharacterSet = (CharacterSet(charactersIn: "&/%").inverted)

    request.httpBody = "From=\(RCValues.sharedInstance.string(forKey: .fromNumber))&To=\(toNumber)&Body=\(message)&MediaUrl=\(mediaURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!)".data(using: String.Encoding.utf8)
    
    //Send Request
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
        print("Did Send Task")
        if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            // Success
            print("Response: \(responseDetails)")
        } else {
            // Failure
            print("Error Occured: \(String(describing: error))")
        }
    }).resume()
}

func sendParentSMS(user: user) {
    guard let toNumber = user.phone else { return }
    guard let name = user.firstName else { return }
    let message = "Hello! \(name) has requested a children's library card at Harris County Public Library. To activate their account, please respond YES."
    
    let childrensRequest = NSMutableURLRequest(url: URL(string:"https://\(RCValues.sharedInstance.string(forKey: .twilioSID)):\(RCValues.sharedInstance.string(forKey: .twilioSecret))@api.twilio.com/2010-04-01/Accounts/\(RCValues.sharedInstance.string(forKey: .twilioSID))/Messages")!)
    childrensRequest.httpMethod = "POST"
    childrensRequest.httpBody = "From=\(RCValues.sharedInstance.string(forKey: .fromNumber))&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
    
    //Send Childrens Request
    URLSession.shared.dataTask(with: childrensRequest as URLRequest, completionHandler: { (data, response, error) in
        print("Finished")
        if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            // Success
            print("Response: \(responseDetails)")
        } else {
            // Failure
            print("Error Occured: \(String(describing: error))")
        }
    }).resume()
}



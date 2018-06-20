//
//  twilioFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation


func sendBarcodeToSMS(toNumber: String, name: String, number: String, mediaURL: String) {

    let message = "Hello \(name)! Bring this code to the circulation desk to finish registration. Until then, use card number \(number) to access online resources."
    
    let request = NSMutableURLRequest(url: URL(string:"https://\(RCValues.sharedInstance.string(forKey: .twilioSID)):\(RCValues.sharedInstance.string(forKey: .twilioSecret))@api.twilio.com/2010-04-01/Accounts/\(RCValues.sharedInstance.string(forKey: .twilioSID))/Messages")!)
    request.httpMethod = "POST"
    let allowedCharacterSet = (CharacterSet(charactersIn: "&/%").inverted)
    request.httpBody = "From=\(RCValues.sharedInstance.string(forKey: .fromNumber))&To=\(toNumber)&Body=\(message)&MediaUrl=\(mediaURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!)".data(using: String.Encoding.utf8)
    
    //Send Request
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
        if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print("Response: \(responseDetails)")
        } else {
            print("Error Occured: \(String(describing: error))")
        }
    }).resume()
    
}

func sendTextToSMS(toNumber: String, name: String, number: String) {
    
    let message = "Hello \(name)! You may now scan your driver's license to checkout materials, or enter your driver's license number online to access digital resources."
    let request = NSMutableURLRequest(url: URL(string:"https://\(RCValues.sharedInstance.string(forKey: .twilioSID)):\(RCValues.sharedInstance.string(forKey: .twilioSecret))@api.twilio.com/2010-04-01/Accounts/\(RCValues.sharedInstance.string(forKey: .twilioSID))/SMS/Messages")!)
    request.httpMethod = "POST"
    request.httpBody = "From=\(RCValues.sharedInstance.string(forKey: .fromNumber))&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
    
    //Send Request
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
        if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print("Response: \(responseDetails)")
        } else {
            print("Error Occured: \(String(describing: error))")
        }
    }).resume()
    
}

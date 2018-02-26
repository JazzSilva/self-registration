//
//  twilioFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation

/*
//This function will send a request to Twilio to send an SMS text
func sendSMS(mediaURL: String)
{
    //Initialize Twilio Settings
    let twilioSID = "ACa43dc90666f387df600823974501aff3"
    let twilioSecret = "637608f493bdbc2cd06a940a0aa39955"
    let fromNumber = "%212408234654"// This is our Twilio assigned number
    let toNumber = phoneNumber() // This number will be the result from the phoneNumber function
    let message = "Hello" + " " + "\(user?.firstName as! String)" + ", you may now use this barcode as your Harris County library card # \(user?.number as! String)"
    let childrensMessage = "Hello, \(user?.firstName as! String) has requested a Harris County Library Kid's Card. To activate card #\(user?.number as! String) please respond YES."
    
    //Build adult request
    let request = NSMutableURLRequest(url: URL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/Messages")!)
    request.httpMethod = "POST"
    print("media URL: is", mediaURL)
    let allowedCharacterSet = (CharacterSet(charactersIn: "&/%").inverted)
    let escapedString = mediaURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)&MediaUrl=\(mediaURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!)".data(using: String.Encoding.utf8)
    
    //Build Children's request
    let childrensRequest = NSMutableURLRequest(url: URL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/Messages")!)
    childrensRequest.httpMethod = "POST"
    childrensRequest.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(childrensMessage)".data(using: .utf8)
    
    //Send Childrens Request
    if user?.childrensCard == true {
        URLSession.shared.dataTask(with: childrensRequest as URLRequest, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    }
        //Send adult Request
    else {
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    }
}*/

func postTwilioRequest(user: user) {
    //Initialize Twilio Settings: Need to change to remote config
    let twilioSID = ""
    let twilioSecret = ""
    let fromNumber = "%212408234654"
    guard let toNumber = user.phone else { return }
    let message = ""
}


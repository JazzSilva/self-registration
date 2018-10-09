//
//  createAccount.swift
//  self-registration
//
//  Created by Jasmin Silva on 5/2/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

func sendDataToTwilio(user: user) {
    var json: [String: Any] = [
        "libraryCard" : user.libraryCardNumber!,
        "license" : user.licenseNumber!,
        "firstName": user.firstName!,
        "middleName": user.middleName!,
        "lastName": user.lastName!,
        "phone": user.phone!,
        "email" : user.email!,
        "pin": user.pin!,
        "mmName": user.mothersMaidenName!,
        "contactPreference": user.contactPreference!,
        "homeLibrary" : user.branchCode!,
        "userProfile" : user.userProfile!,
        "address1": user.address1!,
        "cityState": "\(user.city!), \(user.state!)",
        "zip" : user.zip!,
        "holds": user.holds!,
        "birthdate": user.birthday!,
        "dateCreated": user.dateCreated!,
        "isChild": String(isDLChild(user.birthday!)) //boolean may cause issues
    ]
    
    func convertUserDataToJSON (_ userData : [String: Any]) -> String {
        let jsonSerialization = try? JSONSerialization.data(withJSONObject: userData, options: JSONSerialization.WritingOptions.prettyPrinted)
        let convertedString = String(data: jsonSerialization!, encoding: String.Encoding.utf8)
        return convertedString ?? ""
    }
    
    //need to put this URL in RC values
    let request = NSMutableURLRequest(url: URL(string: Firebase.RemoteConfig.remoteConfig().configValue(forKey: "twilioCreationURL").stringValue!)!)
    
    //need to put this FROM number in variables // RC Values
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = "From=\(Firebase.RemoteConfig.remoteConfig().configValue(forKey: "twilioFromNumber").stringValue!)&To=\(user.phone!)&Parameters=\(convertUserDataToJSON(json))".data(using: String.Encoding.utf8)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
        if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print("response: \(responseDetails)")
        } else {
            print("Error Occured: \(String(describing: error))")
        }
    }).resume()
    
}

func doesAccountExistTwilio(libraryCardNumber: String, phone: String) {
    var json: [String: Any] = [
        "libraryCard" : libraryCardNumber
    ]

    func convertUserDataToJSON (_ userData : [String: Any]) -> String {
        let jsonSerialization = try? JSONSerialization.data(withJSONObject: userData, options: JSONSerialization.WritingOptions.prettyPrinted)
        let convertedString = String(data: jsonSerialization!, encoding: String.Encoding.utf8)
        return convertedString ?? ""
    }
    
    //need to put this URL in RC values
    let request = NSMutableURLRequest(url: URL(string: Firebase.RemoteConfig.remoteConfig().configValue(forKey: "twilioResendURL").stringValue!)!)
    
    //need to put this FROM number in variables // RC Values
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = "From=\(Firebase.RemoteConfig.remoteConfig().configValue(forKey: "twilioFromNumber").stringValue!)&To=\(phone)&Parameters=\(convertUserDataToJSON(json))".data(using: String.Encoding.utf8)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
        if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print("response: \(responseDetails)")
        } else {
            print("Error Occured: \(String(describing: error))")
        }
    }).resume()
    
}













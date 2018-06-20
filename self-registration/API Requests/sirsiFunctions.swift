//
//  sirsiFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

typealias CompletionHandlerWithParameters = (_ parameters: Parameters) -> Void

var sessionToken = ""

var headers: HTTPHeaders = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "x-sirs-clientID": "MOBILECIRC",
    "x-sirs-sessionToken": sessionToken,
    "SD-Originating-App-ID": "cs",
    "SD-Prompt-Return": "USER_PRIVILEGE_OVRCD/SECRET"
]

/// Get session token
func getSessionToken(completion: ((_ success: Bool) -> Void)?) {
    // Do something
    //Get sessionToken
    print("hello", NSDate())
    Alamofire.request(RCValues.sharedInstance.string(forKey: .sessionTokenRequestURL)).responseJSON {
        response in
        guard let post = response.value as? [String:String] else {
            completion?(false)
            return
        }
        if post["sessionToken"] != "" {
            print("log 1")
            print("session token:", post["sessionToken"]!)
            sessionToken = post["sessionToken"]!
            completion?(true)
            return
        }
        else {
            print("log 11")
            completion?(false)
            return
        }
    }
}

/*
func getLibraryCardNumber(user: userViewModel) {
    let libraryCardNumber = "HCPLB" + random9DigitString()
    getSessionToken { (success) -> Void in
        if success {
            print("got session token", NSDate())
            // do second task if success
            if checkAccount(libraryCardNumber) {
                print("card number was already in use")
                getLibraryCardNumber(user: user)
            }
            else {
                print("card number was not in use")
                setLibraryCard(card: libraryCardNumber, user: user)
            }
        }
        else {
            print("did not get session token")
            sessionTokenError()
        }
    }
}
 */

/*
func setLibraryCard(card: String, user: userViewModel) {
    user.libraryCardNumber.value = card
    print("user:\(user), has library card number: \(user.libraryCardNumber.value) which should match card: \(card)")
}
 */

func checkAccount(_ id: String) -> Bool {
    print("checking if account exists", NSDate())
    let lookupURL = RCValues.sharedInstance.string(forKey: .lookupUserID) + id
    print("lookUP URL:", lookupURL)
    let doesExist = Variable<Bool>(false)
    Alamofire.request(lookupURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        guard let post = response.data else {
            return
        }
        do { let json = try JSONSerialization.jsonObject(with: post)
            if let people = json as? [String: Any] {
                print("people:", people)
                if people.keys.contains("user") {
                    doesExist.value = true
                    print("true")
                }
                else {
                    doesExist.value = false
                    print("false")
                }
            }
        }
        catch {print("error parsing json")}
    }
    print("This is the final does exist value:", doesExist.value)
    return doesExist.value
}

func sessionTokenError() {
    print("need to design error pop-UP")
    print("display: Could not get token")
    print("action: Could not connect to network, need to try again later")
    print("action: Make note on staff screen")
}

func doesAccountExist(_ id: String, completion: ((_ success: Bool,_ string: String) -> Void)?) {
    print("checking if account exists", NSDate())
    let lookupURL = RCValues.sharedInstance.string(forKey: .lookupUserID) + id
    print("lookUP URL:", lookupURL)
    Alamofire.request(lookupURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        guard let post = response.data else {
            return
        }
        do { let json = try JSONSerialization.jsonObject(with: post)
            if let people = json as? [String: Any] {
                print("people:", people)
                if people.keys.contains("user") {
                    print("dict is:", people["user"].debugDescription)
                    completion?(true, people["user"].debugDescription)
                }
                else {
                    print("false")
                    completion?(false, "This user cannot be found in Sirsi.")
                }
            }
        }
        catch {print("error parsing json")}
    }
}











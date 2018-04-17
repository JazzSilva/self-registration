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
typealias CompletionHandlerBool = (_ id: String) -> Bool
typealias CompletionHandlerVoid = (_ success: Bool) -> Void

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
        sessionToken = post["sessionToken"] ?? ""
        print("session token:", sessionToken)
        completion?(true)
    }
}

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

func setLibraryCard(card: String, user: userViewModel) {
    user.libraryCardNumber.value = card
    print("user:\(user), has library card number: \(user.libraryCardNumber.value) which should match card: \(card)")
}

/*func getSessionToken() {
    Alamofire.request(RCValues.sharedInstance.string(forKey: .sessionTokenRequestURL)).responseJSON {
        response in
        let post = response.value as! [String:String]
        sessionToken = post["sessionToken"] ?? ""
        print("sessionToken is: \(sessionToken)")
    }
}*/

func sendToSirsi(user: user) {
    getSessionTokenAndParameters(user: user, completionHandler: { myArray -> Void in
        sendJSONtoILS(creationURL: RCValues.sharedInstance.string(forKey: .creationURL), method: .post, parameters: myArray, header: headers) {
            response in
            print("inside response")
        }
        print("closure url: \(myArray)")
    })
}

func sendJSONtoILS(creationURL: String, method: HTTPMethod, parameters: Parameters, header: HTTPHeaders, completionHandler: (String) -> Void) {
    Alamofire.request(creationURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseString { response in
        print("Send JSON to ILS was a success")
    }
}

func getSessionTokenAndParameters(user: user, completionHandler: @escaping CompletionHandlerWithParameters) {
    Alamofire.request(RCValues.sharedInstance.string(forKey: .sessionTokenRequestURL)).responseJSON {
        response in
        let post = response.value as! [String: String]
        sessionToken = post["sessionToken"]!
        
        var myArray = Parameters()
        
        //Test JSon Encoded Parameters
        myArray = [
            "resource": "/user/patron",
            "fields": [
                "barcode" : user.libraryCardNumber!,
                "pin": user.pin!,
                "firstName": user.firstName!,
                "middleName": user.middleName!,
                "lastName": user.lastName!,
                "category02": [
                    "resource": "/policy/patronCategory02",
                    "key": "PHONE" //need to change to user contact preference
                ],
                "language": [
                    "resource": "/policy/language",
                    "key": "ENGLISH"
                ],
                "library":[
                    "resource": "/policy/library",
                    "key": user.branchCode! //need to change to user branch code
                ],
                "profile":[
                    "resource": "/policy/userProfile",
                    "key": user.userProfile!
                ],
                "address1": [
                    [
                        "resource": "/user/patron/address1",
                        "fields": [
                            "code": [
                                "resource": "/policy/patronAddress1",
                                "key": "LINE1"
                            ],
                            "data": user.address1!
                        ]
                    ],
                    [
                        "resource": "/user/patron/address1",
                        "fields": [
                            "code": [
                                "resource": "/policy/patronAddress1",
                                "key": "CITY/STATE"
                            ],
                            "data": "\(user.city!), \(user.state!)"
                        ]
                    ],
                    [
                        "resource": "/user/patron/address1",
                        "fields": [
                            "code": [
                                "resource": "/policy/patronAddress1",
                                "key": "ZIP"
                            ],
                            "data": user.zip!
                        ]
                    ],
                    [
                        "resource": "/user/patron/address1",
                        "fields": [
                            "code": [
                                "resource": "/policy/patronAddress1",
                                "key": "HOMEPHONE"
                            ],
                            "data": user.phone!
                        ]
                    ],
                    [
                        "resource": "/user/patron/address1",
                        "fields": [
                            "code": [
                                "resource": "/policy/patronAddress1",
                                "key": "EMAIL"
                            ],
                            "data": user.email!
                        ]
                    ]
                ],
                "customInformation": [[
                    "resource": "/user/patron/customInformation",
                    "fields": [
                        "code": [
                            "resource": "/policy/patronExtendedInformation",
                            "key": "MM_NAME"
                        ],
                        "data": user.mothersMaidenName!
                    ]
                    ],
                                      [
                                        "resource": "/user/patron/customInformation",
                                        "fields": [
                                            "code": [
                                                "resource": "/policy/patronExtendedInformation",
                                                "key": "FILE_DATE"
                                            ],
                                            "data": user.dateCreated!
                                        ]
                    ],
                                      [
                                        "resource": "/user/patron/customInformation",
                                        "fields": [
                                            "code": [
                                                "resource": "/policy/patronExtendedInformation",
                                                "key": "LICENSE"
                                            ],
                                            "data": user.licenseNumber!
                                        ]
                    ],
                                      [
                                        "resource": "/user/patron/customInformation",
                                        "fields": [
                                            "code": [
                                                "resource": "/policy/patronExtendedInformation",
                                                "key": "HOLDPICKUP"
                                            ],
                                            "data": user.holds!
                                        ]
                    ]
                ],
                "preferredAddress": "1"
            ]
        ]
        completionHandler(myArray)
    }
}


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
    print("This is the final does exist value:",doesExist.value)
    return doesExist.value
}

func sessionTokenError() {
    print("need to design error pop-UP")
    print("display: Could not get token")
    print("action: Could not connect to network, need to try again later")
    print("action: Make note on staff screen")
}

func doesAccountExist(_ id: String, completion: ((_ success: Bool) -> Void)?) {
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
                    print("true")
                    completion?(true)
                }
                else {
                    print("false")
                    completion?(false)
                }
            }
        }
        catch {print("error parsing json")}
    }
}

func accountExistsFunction() {
    print("account exists function run")
}

func accountDoesNotExist() {
    print("account does not exist function run")
}


/*
getSessionTokenTwo { (success) -> Void in
    if success {
        print("got session token", NSDate())
        // do second task if success
        checkAccount(id)
    }
    else {
        print("did not get session token")
        sessionTokenError()
    }
}

 doesAccountExist { (success) -> Void in
    if success {
        print("account does exist")
        accountExists()
    }
    else {
        print("account does not exist")
        accountDoesNotExist()
    }
 }

*/









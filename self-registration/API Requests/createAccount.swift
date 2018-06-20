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


/// Get session token
func getSessionTokenILS(user: user, completion: ((_ success: Bool,_ token: String,_ user: user) -> Void)?) {
    Alamofire.request(RCValues.sharedInstance.string(forKey: .sessionTokenRequestURL)).responseJSON {
        response in
        guard let post = response.value as? [String:String] else {
            completion?(false, "no-token", user)
            return
        }
        if post["sessionToken"] != "" {
            completion?(true, post["sessionToken"]!, user)
            return
        }
        else {
            completion?(false, "nil", user)
            return
        }
    }
}

func choice(_ success: Bool,_ token: String,_ newUser: user) {
    if success {
        sendDataToSirsi(user: newUser, sessionToken: token)
        //send twilio text now that you know a session token has been grabbed
        if newUser.userProfile == constants.accountType.digital { text(user: newUser) }
        // need to only change so only  dl gets texted
        else { sendTextToSMS(toNumber: newUser.phone!, name: newUser.firstName!, number: "999") }
    }
    else {  
       print("log 7 could not get session token - should populate staff screen with further instructions/error/option to resubmit")
    }
}

func sendDataToSirsi(user: user, sessionToken: String) {
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "x-sirs-clientID": "MOBILECIRC",
        "x-sirs-sessionToken": sessionToken,
        "SD-Originating-App-ID": "cs",
        "SD-Prompt-Return": "USER_PRIVILEGE_OVRCD/SECRET"
    ]
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
            "birthDate": user.birthday!,
            "category02": [
                "resource": "/policy/patronCategory02",
                "key": "EMAIL" //need to change to user contact preference
            ],
            "language": [
                "resource": "/policy/language",
                "key": "ENGLISH"
            ],
            "library":[
                "resource": "/policy/library",
                "key": user.branchCode!
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
    
    Alamofire.request(RCValues.sharedInstance.string(forKey: .creationURL), method: .post, parameters: myArray, encoding: JSONEncoding.default, headers: headers).responseString { response in
        print("log 3. Send JSON to ILS was a success")
        print("response is:", response)
    }
}

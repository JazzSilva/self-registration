//
//  sirsiFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Alamofire

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

func getLibraryCardNumber() -> String {
    let libraryCardNumber = "HCPLB" + random9DigitString()
    return libraryCardNumber
}

func sendToSirsi(user: user) {
    getSessionTokenAndParameters(user: user, completionHandler: { myArray -> Void in
        sendJSONtoILS(creationURL: RCValues.sharedInstance.string(forKey: .creationURL), method: .post, parameters: myArray, header: headers) {
            response in
            print("inside response")
        }
        print("inside closure now")
        print("closure url: \(myArray)")
    })
}

func getSessionToken() {
    Alamofire.request(RCValues.sharedInstance.string(forKey: .sessionTokenRequestURL)).responseJSON {
        response in
        let post = response.value as! [String:String]
        sessionToken = post["sessionToken"] ?? ""
        print("sessionToken is: \(sessionToken)")
    }
}

func lookupUserID(id: String) {
    
}

func sendJSONtoILS(creationURL: String, method: HTTPMethod, parameters: Parameters, header: HTTPHeaders, completionHandler: (String) -> Void) {
    Alamofire.request(creationURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseString { response in
        print("Send JSON to ILS was a success")
        print("myArray: \(parameters)")
        print("myHeader: \(header)")
    }
}

func getSessionTokenAndParameters(user: user, completionHandler: @escaping CompletionHandlerWithParameters) {
    Alamofire.request(RCValues.sharedInstance.string(forKey: .sessionTokenRequestURL)).responseJSON {
        response in
        let post = response.value as! [String: String]
        sessionToken = post["sessionToken"]!
        print("sessionToken is: \(sessionToken)")
        
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

//
//  RCValues.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/20/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Firebase

enum ValueKey: String {
    case headerTextPrimaryColor
    case syncUserServer
    case syncConfigServer
    case sessionTokenRequestURL
    case creationURL
    case firebaseStorageReference
    case twilioSID
    case twilioSecret
    case fromNumber
    case lookupUserID
    
    //updated remote config values
    case twilioResendURL
    case twilioFromNumber
    case twilioCreationURL
    case restartTextColor
    case restartButtonColor
    case tabActiveTextColor
    case tabInactiveTextColor
    case tabActiveBackgroundColor
    case tabInactiveBackgroundColor
    case submitTextColor
    case submitButtonColor
    case fieldTextInputColor
    case fieldTextPlaceholderColor
    case headerTextColor
}

class RCValues {
    
    static let sharedInstance = RCValues()
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
        let appDefaults: [String: NSObject] = [
            ValueKey.headerTextPrimaryColor.rawValue : "#FBB03B" as NSObject,
            ValueKey.syncUserServer.rawValue : "http://10.116.15.36:9080" as NSObject,
            ValueKey.syncConfigServer.rawValue: "realm://10.116.15.36:9080/selfRegistrationApp" as NSObject,
            ValueKey.sessionTokenRequestURL.rawValue: "http://10.116.15.70:8080/symws/rest/security/loginUser?clientID=DS_CLIENT&login=SELFREG&password=3563&json=true" as NSObject,
            ValueKey.creationURL.rawValue: "http://10.116.15.70:8080/symws/v1/user/patron" as NSObject,
            ValueKey.firebaseStorageReference.rawValue: "gs://self-registration-5e729.appspot.com" as NSObject,
            ValueKey.twilioSID.rawValue: "ACa43dc90666f387df600823974501aff3" as NSObject,
            ValueKey.twilioSecret.rawValue: "637608f493bdbc2cd06a940a0aa39955" as NSObject,
            ValueKey.fromNumber.rawValue: "%212408234654" as NSObject,
            ValueKey.lookupUserID.rawValue: "http://10.116.15.70:8080/symws/rest/circulation/getUser?userID=" as NSObject,
            //updated remote config values
            ValueKey.twilioResendURL.rawValue: "https://ACa43dc90666f387df600823974501aff3:637608f493bdbc2cd06a940a0aa39955@studio.twilio.com/v1/Flows/FWfa26cbd339fad504144930937933507d/Engagements" as NSObject,
            ValueKey.twilioFromNumber.rawValue: "3462201122" as NSObject,
            ValueKey.twilioCreationURL.rawValue: "https://ACa43dc90666f387df600823974501aff3:637608f493bdbc2cd06a940a0aa39955@studio.twilio.com/v1/Flows/FWb60760aec344167841cf04896e0d51c5/Engagements" as NSObject,
            ValueKey.restartTextColor.rawValue: "#111777" as NSObject,
            ValueKey.restartButtonColor.rawValue: "#111777" as NSObject,
            ValueKey.tabActiveTextColor.rawValue: "#111777" as NSObject,
            ValueKey.tabInactiveTextColor.rawValue: "#111777" as NSObject,
            ValueKey.tabActiveBackgroundColor.rawValue: "#111777" as NSObject,
            ValueKey.tabInactiveBackgroundColor.rawValue: "#111777" as NSObject,
            ValueKey.submitTextColor.rawValue: "#111777" as NSObject,
            ValueKey.submitButtonColor.rawValue: "#111777" as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults)
    }
    
    func fetchCloudValues() {
        //In production, change fetch duration to 43200 (12hrs). A fetch duration of 0 will never use cached data & "activateDebugMode()" is needed.
        let fetchDuration: TimeInterval = 43200
        //activateDebugMode()
        Firebase.RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration, completionHandler: {
            (status, error) in
            
            guard error == nil else {
                print("Uh-oh. Got an error fetching remote values \(String(describing: error))")
                return
            }
            
            Firebase.RemoteConfig.remoteConfig().activateFetched()
            print ("Retrieved values from the cloud!")
            print("Our app's primary color is \(Firebase.RemoteConfig.remoteConfig().configValue(forKey: "headerTextPrimaryColor").stringValue ?? "")")
           
        })
    }
    
    func activateDebugMode() {
        //Tell Remote Config to bypass the client-side throttle.
        let debugSettings = Firebase.RemoteConfigSettings(developerModeEnabled: true)
        Firebase.RemoteConfig.remoteConfig().configSettings = debugSettings!
    }
    
    func color(forKey key: ValueKey) -> UIColor {
        let colorAsHexString = Firebase.RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFFFF"
        let convertedColor = UIColor(hex: colorAsHexString)
        return convertedColor ?? .black
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        return Firebase.RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func string(forKey key: ValueKey) -> String {
        return Firebase.RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func double(forKey key: ValueKey) -> Double {
        if let numberValue = Firebase.RemoteConfig.remoteConfig()[key.rawValue].numberValue {
            return numberValue.doubleValue
        }
        else {
            return 0.0
        }
    }
    
    
}

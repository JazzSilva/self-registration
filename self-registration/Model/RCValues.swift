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
            ValueKey.syncConfigServer.rawValue: "realm://10.116.15.36:9080/selfRegistration" as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults)
    }
    
    func fetchCloudValues() {
        //In production, change fetch duration to 43200 (12hrs). A fetch duration of 0 will never use cached data & "activateDebugMode()" is needed.
        let fetchDuration: TimeInterval = 0
        activateDebugMode()
        Firebase.RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration, completionHandler: {
            [weak self] (status, error) in
            
            guard error == nil else {
                print("Uh-oh. Got an error fetching remote values \(String(describing: error))")
                return
            }
            
            Firebase.RemoteConfig.remoteConfig().activateFetched()
            print ("Retrieved values from the cloud!")
            print("Our app's primary color is \(Firebase.RemoteConfig.remoteConfig().configValue(forKey: "headerTextPrimaryColor").stringValue ?? "")")
            print("Our app's sync user server location is \(Firebase.RemoteConfig.remoteConfig().configValue(forKey: "syncUserServer").stringValue ?? "")")
            print("Our app's sync config server location is \(Firebase.RemoteConfig.remoteConfig().configValue(forKey: "syncConfigServer").stringValue ?? "")")
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

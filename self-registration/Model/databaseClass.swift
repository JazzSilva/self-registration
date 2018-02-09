//
//  objects.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Database {
    //Reusable database class for realm
    
    static let shared = Database()
    var realm = try! Realm()
    private init() { logIn() }
    
    var notificationToken: NotificationToken?
    var usersList = List<user>()
    
    func logIn() {
        // You should make the username and password user-input supported
        SyncUser.logIn(with: .usernamePassword(username: "jasmin.silva@hcpl.net", password: "HCpl2017!", register: false), server: URL(string: "http://127.0.0.1:9080")!) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            
            DispatchQueue.main.async(execute: {
                // Open Realm
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://127.0.0.1:9080/~/selfReg")!)
                )
                
                self.realm = try! Realm(configuration: configuration)
                
                // Set realm notification block
                self.notificationToken = self.realm.observe( { _,_  in self.updateUsersList() } )
                
                self.updateUsersList()
            })
        }}
        
    func updateUsersList() {
            print("did update users")
    }
        
    func create<T: Object>(_ object: T) {
        //We can create any object that subclasses off of the Realm Object
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            //Writes are blocking. So only write ONE TIME, regardless of the number of updates
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }

    func post(_ error: Error) {
        //post any error recieved in the catch block
        NotificationCenter.default.post(name: NSNotification.Name("Realm Error"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        //any view controller can observe realm errors and handle them in a completion block
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Realm Error"), object: nil, queue: nil) { (notification) in completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        //remove the view controller as an observer when done
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("Realm Error"), object: nil)
    }
}

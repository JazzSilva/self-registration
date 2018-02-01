//
//  SecondViewController.swift
//  self-registration
//
//  Created by Jasmin Silva on 12/19/17.
//  Copyright © 2017 Makina. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = userViewModel()
    var notificationToken: NotificationToken?
    
    //NEED TO REMOVE REFERENCE TO DATABASE = MVVM
    var userList: Results<user>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        // Do any additional setup after loading the view, typically from a nib.
        let realm = Database.shared.realm
        userList = realm.objects(user.self)
        
        //Use this print statement to retrieve the default configuration path
        print("3", Realm.Configuration.defaultConfiguration.fileURL)
        print("3 user all sessions: ",realm.configuration.syncConfiguration?.user.allSessions())
        print("3 user is admin: ", realm.configuration.syncConfiguration?.user.isAdmin)
        print("3 user authentication server: ", realm.configuration.syncConfiguration?.user.authenticationServer)
        print("3 sync configuration realm url: ",realm.configuration.syncConfiguration?.realmURL)
        print("3 configuration encryption key: ",realm.configuration.encryptionKey)
        print("3 configuration file url: ", realm.configuration.fileURL)
        print("3 configuration sync configuration: ", realm.configuration.syncConfiguration)
        print("3 schema", realm.schema)
        print("3 realm", realm)
        print("3 object types", realm.configuration.objectTypes)
        print("3 in memory identifier", realm.configuration.inMemoryIdentifier)
        print("3 Realm access TOken", Realm.Configuration.defaultConfiguration.inMemoryIdentifier)
        print("3 Realm User", Realm.Configuration.defaultConfiguration.syncConfiguration?.user)
        print("3 Realm realmURL", Realm.Configuration.defaultConfiguration.syncConfiguration?.realmURL)
        print("3 Realm schema version", Realm.Configuration.defaultConfiguration.schemaVersion)
        print("3 Realm description", Realm.Configuration.defaultConfiguration.description)
        
        
        
        
        //Keep access to notification token, so you can later remove it in ViewWillDisappear
        notificationToken = realm.observe({(notification, realm) in self.tableView.reloadData()})
        Database.shared.observeRealmErrors(in: self) { (error) in print(error ?? "no error") }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //stop observing changes/updates to the realm database
        notificationToken?.invalidate()
        Database.shared.stopObservingErrors(in: self)
    }
    
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? userCell else { return UITableViewCell() }
        let user = userList[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}

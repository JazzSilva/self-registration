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
        
        //Set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "GradientArtboard")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
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

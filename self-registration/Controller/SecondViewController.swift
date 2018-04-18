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
import Firebase

class SecondViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var submitButton: nextButton!
    @IBOutlet weak var logInResponse: UILabel!
    @IBOutlet weak var logInSubview: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var viewModel = userViewModel()
    var notificationToken: NotificationToken?
    var isSearching = Variable<Bool>(false)
    var filteredData: Results<user>!
    
    //NEED TO REMOVE REFERENCE TO DATABASE = MVVM
    var userList: Results<user>!

    @IBAction func logInPressed(_ sender: Any) {
        if usernameText.text == Database.shared.currentUser && passwordText.text == Database.shared.currentPassword {
            self.rightLogIn()
        }
        else {
            self.wrongLogIn()
        }
    }

    func wrongLogIn() {
        usernameText.text = ""
        passwordText.text = ""
        logInResponse.textColor = isInvalidText
        logInResponse.text = "Incorrect password or username"
        shake()
    }
    
    func rightLogIn() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "GradientArtboard")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.tableView.reloadData()
        view.sendSubview(toBack: logInView)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        submitButton.enableSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        // Do any additional setup after loading the view, typically from a nib.

        
        //Set background image
        self.view.bringSubview(toFront: logInView)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "GradientArtboard")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.logInView.insertSubview(backgroundImage, at: 0)
        passwordText.text = ""
        
        let realm = Database.shared.realm
        userList = realm.objects(user.self)
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
    
    private func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:logInSubview.center.x-4, y:logInSubview.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:logInSubview.center.x+4, y:logInSubview.center.y))
        logInSubview.layer.add(animation, forKey: "position")
    }
    
    private func animateIn(newView: UIView) {
        newView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
        newView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            newView.alpha = 1
            newView.transform = CGAffineTransform.identity } , completion: nil )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let realm = Database.shared.realm
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearching.value = false
            view.endEditing(true)
            userList = realm.objects(user.self)
            tableView.reloadData()
        }
        else {
            isSearching.value = true
            //Search fields will match with the following fields. May need to remove a few if search is slowed.
            let firstPredicate = NSPredicate(format: "firstName CONTAINS [c] %@", searchBar.text!)
            let middlePredicate = NSPredicate(format: "middleName CONTAINS [c] %@", searchBar.text!)
            let lastPredicate = NSPredicate(format: "lastName CONTAINS [c] %@", searchBar.text!)
            let addressPredicate = NSPredicate(format: "address1 CONTAINS [c] %@", searchBar.text!)
            let cityPredicate = NSPredicate(format: "city CONTAINS [c] %@", searchBar.text!)
            let zipPredicate = NSPredicate(format: "zip CONTAINS [c] %@", searchBar.text!)
            let emailPredicate = NSPredicate(format: "email CONTAINS [c] %@", searchBar.text!)
            let phonePredicate = NSPredicate(format: "phone CONTAINS [c] %@", searchBar.text!)
            let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [firstPredicate, middlePredicate, lastPredicate, addressPredicate, cityPredicate, zipPredicate, emailPredicate, phonePredicate])
            filteredData = realm.objects(user.self).filter(predicateCompound)
            userList = filteredData
            tableView.reloadData()
        }
    }
    
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        if isSearching.value {
            return filteredData.count
        }
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? userCell else { return UITableViewCell() }
        
        var user = userList[indexPath.row]
        
        if isSearching.value {
            user = filteredData[indexPath.row]
        }
        cell.configure(with: user)
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        print(user.masterKey)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Does Exist") {
            action, index in
            let user = self.userList[index.row]
            guard let id = user.libraryCardNumber else {
                print("the user doesn't have a number to check")
                return
            }
            print("this is where we check account")
            getSessionToken { (success) -> Void in
                if success {
                    print("got session token", NSDate())
                    // do second task if success
                    doesAccountExist(id) { (success) -> Void in
                        if success {
                            print("account does exist")
                            accountExistsFunction()
                        }
                        else {
                            print("account does not exist")
                            accountDoesNotExist()
                        }
                    }
                }
                else {
                    print("did not get session token")
                    sessionTokenError()
                }
            }
        }
        
        let send = UITableViewRowAction(style: .normal, title: "Resend Barcode")
        { action, index in
            let user = self.userList[index.row]
            guard let phone = user.phone else {
                print("no phone # on file")
                return
            }
            text(user: user)
        }
        send.backgroundColor = .lightGray
        edit.backgroundColor = .green
        return [send, edit]
    }

}

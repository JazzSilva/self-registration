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
        logInResponse.textColor = constants.colors.redInvalid
        logInResponse.text = constants.labels.incorrectLogIn
        shake()
    }
    
    func rightLogIn() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundArtboard")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.tableView.reloadData()
        view.sendSubview(toBack: logInView)
    }
    
    override func viewDidLoad() {
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = constants.colors.pink
        textFieldInsideSearchBar?.font = UIFont(name: "RobotoSlab-Regular", size: 18.0)
        submitButton.enableSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        // Do any additional setup after loading the view, typically from a nib.

        self.view.bringSubview(toFront: logInView)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundArtboard")
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
        NotificationCenter.default.removeObserver(self)
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
            let lastPredicate = NSPredicate(format: "lastName CONTAINS [c] %@", searchBar.text!)
            let addressPredicate = NSPredicate(format: "address1 CONTAINS [c] %@", searchBar.text!)
            let cityPredicate = NSPredicate(format: "city CONTAINS [c] %@", searchBar.text!)
            let zipPredicate = NSPredicate(format: "zip CONTAINS [c] %@", searchBar.text!)
            let emailPredicate = NSPredicate(format: "email CONTAINS [c] %@", searchBar.text!)
            let phonePredicate = NSPredicate(format: "phone CONTAINS [c] %@", searchBar.text!)
            let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [firstPredicate, lastPredicate, addressPredicate, cityPredicate, zipPredicate, emailPredicate, phonePredicate])
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
        
        let edit = UITableViewRowAction(style: .normal, title: "See Patron Details") {
            action, index in
            let user = self.userList[index.row]
            /*
            guard let id = user.libraryCardNumber else {
                print("the user doesn't have a number to check")
                return
            }
            */
            
            do {
                let view = self.parseUserNotInSirsi(xib: detailPatronXib(), user: user)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.exitButton.addTarget(self, action: #selector(self.exitTableDetailView(sender:)), for: .touchUpInside)
                self.tableView.tableHeaderView = view
                self.tableView.tableHeaderView?.isUserInteractionEnabled = true
                view.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
                view.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
                view.heightAnchor.constraint(equalTo: self.tableView.heightAnchor).isActive = true
                self.tableView.tableHeaderView?.layoutIfNeeded()
                self.tableView.tableHeaderView = self.tableView.tableHeaderView
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
                self.tableView.isScrollEnabled = false
            }
            
        }
        edit.backgroundColor = constants.colors.greenValid
        return [edit]
        
    }
    
    @objc func exitTableDetailView(sender: AnyObject) {
        self.tableView.tableHeaderView = nil
        self.tableView.layoutIfNeeded()
        self.tableView.layoutSubviews()
        self.tableView.reloadData()
        self.tableView.isScrollEnabled = true
    }
    
    func parseResponseDetail(xib: detailPatronXib, string: String, user: user) -> detailPatronXib {
        xib.currentUser = user
        xib.resendButton.setTitle(constants.buttons.resendCode, for: .normal)
        xib.firstLabel.text = string.capturedGroups(withRegex: "firstName = (.*);").first
        xib.middleLabel.text = string.capturedGroups(withRegex: "middleName = (.*);").first
        xib.lastLabel.text = string.capturedGroups(withRegex: "lastName = (.*);").first
        xib.cityLabel.text = string.capturedGroups(withRegex: "STATE\";[\n][ *].*entryValue = \"(.*),").first
        xib.stateLabel.text = string.capturedGroups(withRegex: "STATE\";[\n][ *].*entryValue = \".*, (.*)\"").first
        xib.zipLabel.text = string.capturedGroups(withRegex: "ZIP;[\n][ *].*entryValue = (.*);").first
        xib.addressLabel.text = string.capturedGroups(withRegex: "LINE1;[\n][ *].*entryValue = \"(.*)\"").first
        xib.emailLabel.text = string.capturedGroups(withRegex: "EMAIL;[\n][ *].*entryValue = \"(.*)\"").first
        xib.phoneLabel.text = string.capturedGroups(withRegex: "HOMEPHONE;[\n][ *].*entryValue = (.*);").first
        xib.homeLibraryLabel.text = string.capturedGroups(withRegex: "libraryID = (.*);").first
        xib.holdsLabel.text = string.capturedGroups(withRegex: "HOLDPICKUP;[\n][ *].*entryValue = (.*);").first
        xib.userIDLabel.text = string.capturedGroups(withRegex: "userID = (.*);").first
        xib.alternateIDLabel.text = string.capturedGroups(withRegex: "altID = \"(.*)\"").first
        xib.userStandingLabel.text = string.capturedGroups(withRegex: "userStandingID = (.*);").first
        xib.profileType.text = string.capturedGroups(withRegex: "profileID = (.*);").first
        xib.dateCreatedLabel.text = string.capturedGroups(withRegex: "FILE_DATE\";[\n][ *].*entryValue = \"(.*)\"").first
        return xib
    }
    
    func parseUserNotInSirsi(xib: detailPatronXib, user: user) -> detailPatronXib {
        xib.currentUser = user
        xib.resendButton.setTitle(constants.buttons.createAccount, for: .normal)
        xib.firstLabel.text = user.firstName
        xib.middleLabel.text = user.middleName
        xib.lastLabel.text = user.lastName
        xib.cityLabel.text = user.city
        xib.stateLabel.text = user.state
        xib.zipLabel.text = user.zip
        xib.addressLabel.text = user.address1
        xib.emailLabel.text = user.email
        xib.phoneLabel.text = user.phone
        xib.homeLibraryLabel.text = user.branchCode
        xib.holdsLabel.text = user.holds
        xib.userIDLabel.text = user.libraryCardNumber
        xib.alternateIDLabel.text = ""
        xib.userStandingLabel.text = constants.labels.accountNotInSirsi //need to update if in Sirsi
        xib.profileType.text = user.userProfile
        xib.dateCreatedLabel.text = user.dateCreated
        return xib
    }

}

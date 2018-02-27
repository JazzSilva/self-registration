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
    
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var logInResponse: UILabel!
    @IBOutlet weak var logInSubview: UIView!
    
    var viewModel = userViewModel()
    var notificationToken: NotificationToken?
    
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
        view.sendSubview(toBack: logInView)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        // Do any additional setup after loading the view, typically from a nib.
        let realm = Database.shared.realm
        userList = realm.objects(user.self)
        
        //Set background image
        self.view.bringSubview(toFront: logInView)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "GradientArtboard")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.logInView.insertSubview(backgroundImage, at: 0)
        
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
        let user = userList[indexPath.row]
        print(user.masterKey)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let send = UITableViewRowAction(style: .normal, title: "Resend Barcode") { action, index in
            let user = self.userList[index.row]
            guard let phone = user.phone else {
                print("no phone # on file")
                return
            }
            text(user: user)
        }
        send.backgroundColor = .lightGray
        return [send]
    }
}

//
//  LogInController.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/11/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class logInController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: nextButton!
    @IBOutlet weak var responseLabel: UILabel!
    
    override func viewDidLoad() {
        //Set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradientArtboardMesh")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        //animation
        animateIn(newView: logInView)
        
        //Set Submit button settings
        submitButton.enableSettings()
        
        //Hide response
        responseLabel.text = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        Database.shared.logIn(username: usernameField.text!, password: passwordField.text!, vc: self)
    }
    
    func wrongInput() {
        shake()
        usernameField.text = ""
        passwordField.text = ""
        responseLabel.textColor = isInvalidText
        responseLabel.text = "Incorrect username or password"
    }
    
    func correctInput() {
        performSegue(withIdentifier: "logInSegue", sender: nil)
    }
    
    private func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:logInView.center.x-4, y:logInView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:logInView.center.x+4, y:logInView.center.y))
        logInView.layer.add(animation, forKey: "position")
    }
    
    private func animateIn(newView: UIView) {
        newView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
        newView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            newView.alpha = 1
            newView.transform = CGAffineTransform.identity } , completion: nil )
    }
    
}

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
    
    override func viewDidLoad() {
        //Set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "GradientArtboard")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func logInAttempt() {
        
        
    }
    
}

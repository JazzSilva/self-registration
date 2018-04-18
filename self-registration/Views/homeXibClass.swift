//
//  homeXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import LilitabSDK
import RxSwift

class homeXib: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var swipeButton: nextButton!
    @IBOutlet weak var button: nextButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var accountExistsButton: nextButton!
    
    @IBOutlet var swipedView: UIView!
    @IBOutlet var accountExists: UIView!
    
    
    @IBOutlet weak var firstSwipe: UITextField!
    @IBOutlet weak var lastSwipe: UITextField!
    @IBOutlet weak var dobSwipe: UITextField!
    @IBOutlet weak var addressSwipe: UITextField!
    @IBOutlet weak var citySwipe: UITextField!
    @IBOutlet weak var stateSwipe: UITextField!
    @IBOutlet weak var zipSwipe: UITextField!
    @IBOutlet weak var licenseSwipe: UITextField!
    
    //User Dictionaries
    var userDict = Dictionary<Int, String>()
    var userInformation = Dictionary<String, [String]>()
    var lottieAnimation: LOTAnimationView?
    let lilitab = AppDelegate.swipe
    let animationView = LOTAnimationView(name: "account_success")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        //initialize Lilitab
        //Enable Basic Scanner Settings
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("homeView", owner: self, options: nil)
        addSubview(contentView)
        animateLottie()
        button.enableSettings()
        topLabel.textColor = RCValues.sharedInstance.color(forKey: .headerTextPrimaryColor) 
        contentView.clipsToBounds = false
        contentView.frame = .init(x: 0, y: 0, width: 800, height: 500)
        contentView.shadowColor = .black
        contentView.shadowOpacity = 0.20
        contentView.shadowOffset = CGPoint(x: 0, y: 0)
        contentView.shadowRadius = 14
        lilitab?.scanForConnectedAccessories()
        lilitab?.enableSwipe = true
        lilitab?.swipeTimeout = 0
        lilitab?.allowMultipleSwipes = true
        lilitab?.ledState = LilitabSDK_LED_Mode.LED_On
        lilitab?.swipeBlock = {(_ swipeData: [AnyHashable: Any]?) -> Void in
        self.swipeFunc(swipeData)}
    }
    
    private func animateLottie() {
        if let image = imageView {
            image.addSubview(animationView)
            animationView.frame = CGRect(x: 20, y: -05, width: 185, height: 185)
            animationView.animationSpeed = 2.0
            animationView.play(fromFrame: 0, toFrame: 35, withCompletion: {completion in
                self.animationView.pause()
                self.animationView.animationSpeed = 2.0
            })
            animationView.contentMode = .scaleAspectFit
        }
    }

    func animateSwipe() {
        topLabel.text = "Great, let's get started!"
        animationView.play(fromFrame: 35, toFrame: 60, withCompletion: { completion in
            self.animateIn()
        })
    }
    
    func animateError() {
        topLabel.text = "Whoops!"
        self.accountExistsAction()
    }
    
    private func accountExistsAction() {
        self.addSubview(accountExists)
        accountExists.center = CGPoint(x: self.center.x, y: self.center.y + 50)
        accountExists.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        animationView.transform = CGAffineTransform.identity
        accountExists.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.accountExists.alpha = 1
            self.accountExists.transform = CGAffineTransform.identity
            self.animationView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        }
        accountExistsButton.enableSettings()
    }
    
    private func animateIn() {
        self.addSubview(swipedView)
        swipedView.center = CGPoint(x: self.center.x, y: self.center.y + 50) // might be -50. need to test
        swipedView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        animationView.transform = CGAffineTransform.identity
        swipedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.swipedView.alpha = 1
            self.swipedView.transform = CGAffineTransform.identity
            self.animationView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        }
        swipeButton.enableSettings()
    }
    
    @objc func removeButton(sender: AnyObject) {
        self.button.removeFromSuperview()
    }
    
    @objc func removeSwipeButton(sender: AnyObject) {
        self.swipeButton.removeFromSuperview()
    }
}


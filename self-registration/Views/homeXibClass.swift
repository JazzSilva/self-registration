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
    @IBOutlet weak var unableToReadSwipeButton: nextButton!
    
    @IBOutlet var swipedView: UIView!
    @IBOutlet var accountExists: UIView!
    @IBOutlet var unableToReadDataView: UIView!
    
    
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
    var newLibraryCard = libraryCard()
    weak var lilitab = LilitabSDK.singleton()
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
        contentView.shadowOpacity = 0.80
        contentView.shadowOffset = CGPoint(x: 2, y: 2)
        contentView.shadowRadius = 14
        lilitab?.scanForConnectedAccessories()
        lilitab?.enableSwipe = true
        lilitab?.swipeTimeout = 0
        lilitab?.allowMultipleSwipes = false
        lilitab?.ledState = LilitabSDK_LED_Mode.LED_On
        lilitab?.swipeBlock = { (_ swipeData: Any?) -> Void in
            self.swipeFunc(swipeData)
            self.lilitab?.ledState = LilitabSDK_LED_Mode.LED_Blink2
        }
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

    func animateSuccessfulSwipeView() {
        topLabel.text = "Great, let's get started!"
        self.firstSwipe.text = self.userInformation["First"]?.first
        self.lastSwipe.text = self.userInformation["Last"]?.first
        self.addressSwipe.text = self.userInformation["Address 1"]?.first
        self.citySwipe.text = self.userInformation["City"]?.first
        self.dobSwipe.text = dateStringFormatted(date: (self.userInformation["DOB"]?.first)!)
        self.stateSwipe.text = self.userInformation["State"]?.first
        self.zipSwipe.text = self.userInformation["Zip"]?.first
        self.licenseSwipe.text = newLibraryCard.driversLicenseWithCorrectedPrefix
        
        animationView.play(fromFrame: 35, toFrame: 60, withCompletion: { completion in
            self.contentView.addSubview(self.swipedView)
            self.swipedView.superview?.bringSubview(toFront: self.swipedView)
            self.swipedView.center = CGPoint(x: self.contentView.center.x - 105, y: self.contentView.center.y - 35)
            //self.swipedView.center = CGPoint(x: self.center.x, y: self.center.y + 50) // might be -50. need to test
            self.swipedView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.animationView.transform = CGAffineTransform.identity
            self.swipedView.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.swipedView.alpha = 1
                self.swipedView.transform = CGAffineTransform.identity
                self.animationView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            }
            self.swipeButton.enableSettings()
        })
    }
    
    func animateAccountExistsView() {
        topLabel.text = "Whoops!"
        self.contentView.addSubview(accountExists)
        accountExists.superview?.bringSubview(toFront: accountExists)
        accountExists.center = CGPoint(x: self.contentView.center.x - 105, y: self.contentView.center.y - 35)
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
    
    func animateUnableToReadSwipeView() {
        topLabel.text = "Sorry!"
        self.contentView.addSubview(unableToReadDataView)
        unableToReadDataView.superview?.bringSubview(toFront: unableToReadDataView)
        unableToReadDataView.center = CGPoint(x: self.contentView.center.x - 105, y: self.contentView.center.y - 35)
        unableToReadDataView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        unableToReadDataView.transform = CGAffineTransform.identity
        unableToReadDataView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.unableToReadDataView.alpha = 1
            self.unableToReadDataView.transform = CGAffineTransform.identity
            self.animationView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        }
        unableToReadSwipeButton.enableSettings()
    }
    
    @objc func removeButton(sender: AnyObject) {
        self.button.removeFromSuperview()
    }
    
    @objc func removeSwipeButton(sender: AnyObject) {
        self.swipeButton.removeFromSuperview()
    }
}


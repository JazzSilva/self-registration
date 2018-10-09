//
//  detailPatronXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 4/19/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class detailPatronXib: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var homeLibraryLabel: UILabel!
    @IBOutlet weak var holdsLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var alternateIDLabel: UILabel!
    @IBOutlet weak var userStandingLabel: UILabel!
    @IBOutlet weak var profileType: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    var currentUser: user!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("detailPatronView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = .init(x: 0, y: 0, width: 900, height: 353)
        contentView.clipsToBounds = false
        contentView.shadowColor = .black
        contentView.shadowOpacity = 0.60
        contentView.shadowOffset = CGPoint(x: 2, y: 2)
        contentView.shadowRadius = 14
    }
    
    @IBAction func resendText(_ sender: Any) {
        
        doesAccountExistTwilio(libraryCardNumber: userIDLabel.text!, phone: phoneLabel.text!)
        
        /*
        if userStandingLabel.text != "Account Not In Sirsi" {
            //resend text to patron
            if profileType.text == "A" {
                //sendTextToSMS(toNumber: phoneLabel.text!, name: firstLabel.text!, number: userIDLabel.text!)
            }
            else {
                //retext(cardNumber: userIDLabel.text!, name: firstLabel.text!, toNumber: phoneLabel.text!)
            }
            //after button is pressed, change text so staff know button was pressed
            resendButton.setTitle("Resending Text", for: .normal)
        }
        else {
            guard let patron = currentUser else {
                print("couldn't initialize patron as current user")
                return
            }
            getSessionTokenILS(user: patron) { (success, token, user) -> Void in
                print("retry sirsi")
                choice(success, token, user)
                self.resendButton.setTitle("Recreating Account", for: .normal)
                self.userStandingLabel.text = "OK"
            }
        */
    }
    
}

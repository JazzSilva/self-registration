//
//  userCell.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/31/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import Realm


class userCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var middleNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func configure(with user: user) {
        firstNameLabel.text = user.firstName
        middleNameLabel.text = user.middleName
        lastNameLabel.text = user.lastName
        addressLabel.text = user.address1
        cityLabel.text = user.city
        stateLabel.text = user.state
        zipLabel.text = user.zip
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
}
